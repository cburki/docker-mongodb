Summary
-------

MongoDB server image. It extends the official [mongo](https://hub.docker.com/_/mongo/)
image in the way that it setup authorization for a given administrator. For 
persistent storage, you could use the cburki/volume-data container to store the
database data.

This image can also be used to execute a mongo shell to connect to a server.


Build the image
---------------

To create this image, execute the following command in the docker-mongodb folder.

    docker build -t cburki/mongodb .


Configure the image
-------------------

Access control is disabled by default. Yo can enable it by providing a user
administrator username, password and role to the following environment variables.

    - MONGODB_ADMIN_PASSWORD : Password for the administrator
    - MONGODB_ADMIN_USERNAME : Username for the administrator (default to admin)
    - MONGODB_ADMIN_ROLE : The role to set the administrator (default to userAdminAnyDatabase)

The username is set to *admin* if not set to the variable *MONGODB_ADMIN_USERNAME*.
The role is set to *userAdminAnyDatabase* if the *MONGODB_ADMIN_ROLE* variable
is not set.

Note that it is highly recommended to set the access control for obvious security
reasons.


Run the image
-------------

When you run the imnage, you will bind the port 27017 and set the environment
variable to setup authorization. Not that binding the port 27017 could be a
potential security risk. It is safer not to bind it and access the server
through a container that is linked to this one.

    docker run \
        --name mongodb \
        --volumes-from mongodb-data \
        -d \
        -e MONGODB_ADMIN_USERNAME=my_admin_username \
        -e MONGODB_ADMIN_PASSWORD=my_secret_password \
        -e MONGODB_ADMIN_ROLE=a_valid_mongodb_role \
        -p 27017:27017 \
        cburki/mongodb:latest

The volume data container could be started using the following command.

    docker run \
        --name mongodbdb-data \
        -d \
        cburki/volume-data:latest

If as recommended you do not bind the port 27017, you can for example run a
mongo shell container which is linked to the mongo server.

    docker run \
        --rm \
        -- link mongodb:mongodb \
        -i \
        -t \
        cburki/mongodb:latest \
        mongo mongodb:27017/admin -u my_admin_username -p


Run the mongo shell using the image
-----------------------------------

The mongo shell could be executed using the following command.

    docker run \
        --rm \
        -i \
        -t \
        cburki/mongodb:latest \
        mongo --help
