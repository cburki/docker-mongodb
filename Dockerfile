FROM debian:jessie
MAINTAINER Christophe Burki, christophe.burki@gmail.com

ENV GOSU_VERSION 1.10
ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.1

# Install system requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget && \
    apt-get autoremove -y && \
    apt-get clean

# Install mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    mongodb-org=$MONGO_VERSION \
	mongodb-org-server=$MONGO_VERSION \
	mongodb-org-shell=$MONGO_VERSION \
	mongodb-org-mongos=$MONGO_VERSION \
	mongodb-org-tools=$MONGO_VERSION && \
    apt-get autoremove -y && \
    apt-get clean

# Install gosu
RUN wget -O /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 && \
    chmod a+x /usr/local/bin/gosu

# Copy configurations
COPY configs/mongod-auth.conf /opt/mongod-auth.conf
COPY configs/mongod-noauth.conf /opt/mongod-noauth.conf

# Copy setup scripts
COPY scripts/run.sh /opt/run.sh
RUN chmod 755 /opt/run.sh

EXPOSE 27017

CMD ["/opt/run.sh"]
