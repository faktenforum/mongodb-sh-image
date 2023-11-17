# Image for mongosh (MongoDB Shell) this can be used for setup purposes
FROM debian:buster-slim

# Install mongosh
RUN apt-get update && apt-get install -y wget gnupg \
    && wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - \
    && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list \
    && apt-get update \
    && apt-get install -y mongodb-mongosh

# Set the working directory
WORKDIR /root

# The default command to run if none is specified (can be overridden by docker-compose)
CMD ["mongosh"]
