FROM mongo:latest
MAINTAINER Christophe BUrki, christophe.burki@gmail.com

ENV GOSU_VERSION 1.10

# Install system requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget && \
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

VOLUME ["/data"]

EXPOSE 27017

CMD ["/opt/run.sh"]
