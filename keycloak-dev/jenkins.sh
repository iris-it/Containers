#!/usr/bin/env bash

NAME="keycloak-dev"
DOCKER_USERNAME="user"
DOCKER_PASSWORD="${REGISTRY_PASSWORD}"
IMAGE_NAME="${DOCKER_USERNAME}/${NAME}:${GIT_COMMIT}"

APP_ID="/${NAME}"
HOST_PATH="/var/data/${NAME}"
HAPROXY_VHOST=""

INSTANCE_RAM=512
INSTANCE_CPU=2
INSTANCE_DISK=1024
INSTANCE_NUMBER=1

MYSQL_DATABASE=""
MYSQL_PORT_3306_TCP_ADDR=""
MYSQL_PORT_3306_TCP_PORT=""
MYSQL_USER=""

KEYCLOAK_USER=""
KEYCLOAK_PASSWORD=""

cp -f marathon.json marathon.json.tmp

sed -i "s|__DOCKER_IMAGE_NAME__|${IMAGE_NAME}|g" marathon.json.tmp

sed -i "s|__APP_ID__|${APP_ID}|g" marathon.json.tmp
sed -i "s|__HOST_PATH__|${HOST_PATH}|g" marathon.json.tmp
sed -i "s|__HAPROXY_VHOST__|${HAPROXY_VHOST}|g" marathon.json.tmp
sed -i "s|__INSTANCE_RAM__|${INSTANCE_RAM}|g" marathon.json.tmp
sed -i "s|__INSTANCE_CPU__|${INSTANCE_CPU}|g" marathon.json.tmp
sed -i "s|__INSTANCE_DISK__|${INSTANCE_DISK}|g" marathon.json.tmp
sed -i "s|__INSTANCE_NUMBER__|${INSTANCE_NUMBER}|g" marathon.json.tmp

sed -i "s|__MYSQL_DATABASE__|${MYSQL_DATABASE}|g" changeDatabase.xsl
sed -i "s|__MYSQL_PORT_3306_TCP_ADDR__|${MYSQL_PORT_3306_TCP_ADDR}|g" changeDatabase.xsl
sed -i "s|__MYSQL_PORT_3306_TCP_PORT__|${MYSQL_PORT_3306_TCP_PORT}|g" changeDatabase.xsl
sed -i "s|__MYSQL_USER__|${MYSQL_USER}|g" changeDatabase.xsl
sed -i "s|__MYSQL_PASSWORD__|${database_password}|g" changeDatabase.xsl

sed -i "s|__KEYCLOAK_USER__|${KEYCLOAK_USER}|g" marathon.json.tmp
sed -i "s|__KEYCLOAK_PASSWORD__|${KEYCLOAK_PASSWORD}|g" marathon.json.tmp

rm marathon.json
mv marathon.json.tmp marathon.json

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
docker build -t ${IMAGE_NAME} `pwd -P`
docker push ${IMAGE_NAME}

curl -X PUT -H "Content-type: application/json" -u admin:${MARATHON_PASSWORD} -d @marathon.json "http://datacenter.com:8080/v2/apps?force=true"