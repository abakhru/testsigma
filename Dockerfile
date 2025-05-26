FROM ubuntu:20.04
WORKDIR /opt/app

# Do not change this line position, because its used by the below nginx apt install command
# COPY deploy/docker/nginx.repo /etc/apt/sources.list.d/nginx.list

RUN apt-get update && apt-get install -y nginx && apt-get clean
RUN apt-get install -y openssl libssl-dev wget zip unzip && apt-get clean
RUN apt-get install -y openjdk-11-jdk && apt-get clean

RUN mkdir /etc/nginx/logs
RUN mkdir /opt/app/lib
RUN mkdir /opt/app/ts_data

COPY deploy/docker/nginx.conf /etc/nginx/nginx.conf
COPY deploy/docker/cacerts /usr/lib/jvm/java-11-openjdk-amd64/lib/security/
COPY deploy/docker/entrypoint.sh /opt/app/entrypoint.sh
COPY ui/dist/testsigma-angular /opt/app/angular/
COPY server/target/testsigma-server.jar /opt/app/testsigma-server.jar
COPY server/target/lib/ /opt/app/lib/
COPY server/src/main/scripts/posix/start.sh /opt/app/

RUN rm -f /etc/nginx/sites-enabled/default
RUN chmod +x /opt/app/start.sh
RUN chmod +x /opt/app/entrypoint.sh

ENV IS_DOCKER_ENV=true
ENV MYSQL_HOST_NAME=${MYSQL_HOST_NAME:-mysql}
ENV TS_DATA_DIR=/opt/app/ts_data
ENV TESTSIGMA_WEB_PORT=${TESTSIGMA_WEB_PORT:-443}
ENV TESTSIGMA_SERVER_PORT=${TESTSIGMA_SERVER_PORT:-9090}

EXPOSE $TESTSIGMA_WEB_PORT
EXPOSE $TESTSIGMA_SERVER_PORT

ENTRYPOINT ["/opt/app/entrypoint.sh"]
