#!/bin/bash

SETUP_STATUS=/opt/setupmongo.status

if [ ! -f ${SETUP_STATUS} ]; then

    # Create data folders and set permissions
    mkdir -p /data/db /data/configdb
    chown mongodb: /data/db /data/configdb

    if [ -n "${MONGODB_ADMIN_PASSWORD}" ]; then

        USERNAME=admin
        ROLE=userAdminAnyDatabase
        if [ -n "${MONGODB_ADMIN_USERNAME}" ]; then
            USERNAME=${MONGODB_ADMIN_USERNAME}
        fi
        if [ -n "${MONGODB_ADMIN_ROLE}" ]; then
            ROLE=${MONGODB_ADMIN_ROLE}
        fi

        # Start mongod without access control
        gosu mongodb mongod --port 27017 --dbpath /data/db --syslog --fork

        # Create the adminstrator user and authorization
        echo "db.createUser({user: \"${USERNAME}\", pwd: \"${MONGODB_ADMIN_PASSWORD}\", roles: [{role: \"${ROLE}\", db: \"admin\"}]})" >> /tmp/create_admin.js
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
