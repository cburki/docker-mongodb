#!/bin/bash

SETUP_STATUS=/opt/setupmongo.status

if [ ! -f ${SETUP_STATUS} ]; then

    if [ -n "$MONGODB_ADMIN_PASSWORD" ]; then

        PIDFILE=/tmp/mongo.pid
 
        # Start mongod without access control
        gosu mongodb mongod --port 27017 --dbpath /data/db --pidfilepath ${PIDFILE} --syslog --fork

        # Setup authorization
        echo "db.createUser({user: \"admin\", pwd: \"${MONGODB_ADMIN_PASSWORD}\", roles: [{role: \"userAdminAnyDatabase\", db: \"admin\"}]})" >> /tmp/create_admin.js
        mongo --port 27017 admin /tmp/create_admin.js

        # Shutdown mongod
        echo "db.shutdownServer()" >> /tmp/shutdown.js
        mongo --port 27017 admin /tmp/shutdown.js

        # Use the configuration with authorization enabled
        cp /opt/mongod-auth.conf /etc/mongod.conf
    else

        # Use the configuration with authorization disabled
        cp /opt/mongod-noauth.conf /etc/mongod.conf
    fi

    echo "done" >> ${SETUP_STATUS}
fi

exec gosu mongodb /usr/bin/mongod --config /etc/mongod.conf "$@"
