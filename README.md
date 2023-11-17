# mongodb-sh-image
Small docker image for init mongodb in cloud deployment like minio-client.


# How to use it
Use it for init deployments f.e. in your docker compose file

```yaml
mongodb: # Add a MongoDB instance
    image: mongo:latest # Use a minimal version of MongoDB
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGODB_ROOT_USER}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGODB_ROOT_PASSWORD}

mongodb-sh:
    image: ghcr.io/faktenforum/mongodb-sh:latest
    depends_on:
        - mongodb
    environment:
        MONGODB_ROOT_USER: ${MONGODB_ROOT_USER}
        MONGODB_ROOT_PASSWORD: ${MONGODB_ROOT_PASSWORD}
        MONGODB_CUSTOM_USER: ${MONGODB_CUSTOM_USER}
        MONGODB_CUSTOM_PASSWORD: ${MONGODB_CUSTOM_PASSWORD}
        MONGODB_CUSTOM_DB: ${MONGODB_CUSTOM_DB}
        MONGODB_HOST: ${MONGODB_HOST}
        MONGODB_PORT: ${MONGODB_PORT}

    entrypoint: >
        /bin/sh -c "
        echo 'Waiting for mongodb to be ready...' &&
        sleep 5 &&
        set -e
        mongosh -u ${MONGODB_ROOT_USER} -p ${MONGODB_ROOT_USER} --authenticationDatabase admin mongodb://${MONGODB_HOST}:${MONGODB_PORT}<<EOF
        use ${MONGODB_CUSTOM_DB}

        db.createUser({
        user: '${MONGODB_CUSTOM_USER}',
        pwd: '${MONGODB_CUSTOM_PASSWORD}',
        roles: [{ role: 'readWrite', db: '${MONGODB_CUSTOM_DB}' },
        { role: 'dbOwner', db: '${MONGODB_CUSTOM_DB}' }],
        });
        EOF"**

```