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
      echo 'Waiting for MongoDB to be ready...' &&
      until mongosh --quiet -u ${MONGODB_CUSTOM_USER} -p ${MONGODB_ROOT_PASSWORD} --authenticationDatabase admin mongodb://mongodb:${MONGODB_PORT} --eval 'db.runCommand({ ping: 1 })'; do
        sleep 1
      done &&
      echo 'MongoDB is ready. Creating user and setting up database...' &&
      mongosh -u ${MONGODB_ROOT_USER} -p ${MONGODB_ROOT_PASSWORD} --authenticationDatabase admin mongodb://mongodb:${MONGODB_PORT} --eval '
        db = db.getSiblingDB(\"${MONGODB_CUSTOM_DB}\");
        db.createUser({
          user: \"${MONGODB_CUSTOM_USER}\",
          pwd: \"${MONGODB_CUSTOM_PASSWORD}\",
          roles: [{ role: \"readWrite\", db: \"${MONGODB_CUSTOM_DB}\" },
                  { role: \"dbOwner\", db: \"${MONGODB_CUSTOM_DB}\" }]
        });
      '"

```