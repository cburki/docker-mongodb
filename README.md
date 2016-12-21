Summary
-------

MongoDB server image. It extend the official [mongo](https://hub.docker.com/_/mongo/) 
image in the way that it setup authorization if an administrator password is
given when running the image. For persistent storage, you could use the 
cburki/volume-data container to store the database data.

This image can also be used to execute a mongo shell to connect to a
server.


Build the image
---------------

To create this image, execute the following command in the docker-mongodb
folder.

    docker build -t cburki/mongodb .


Configure the image
-------------------

Access control is disabled by default. Yo can enable it by providing a user
administrator password to the following environment variable. The administrator
username is *admin*.

    - MONGODB_ADMIN_PASSWORD : Administrator password for authorization.


Run the image
-------------

When you run the imnage, you will bind the port 27017 and set the environment
variable to setup authorization.

    docker run \
        --name mongodb \
        --volumes-from mongodb-data \
        -d \
        -e MONGODB_ADMIN_PASSWORD=my_secret_password \
        -p 27017:27017 \
        cburki/mongodb:latest

The volume data container could be started using the following command.

    docker run \
        --name mongodbdb-data \
        -d \
        cburki/volume-data:latest


Run the mongo shell using the image
-----------------------------------

The mongo shell could be executed using the following command.

    docker run \
        --rm \
        -i \
        -t \
        cburki/mongodb:latest \
        mongo --help
