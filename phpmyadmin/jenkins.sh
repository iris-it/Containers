#!/usr/bin/env bash

NAME="phpmyadmin"
DOCKER_USERNAME="user"
DOCKER_PASSWORD="${REGISTRY_PASSWORD}"
IMAGE_NAME="${DOCKER_USERNAME}/${NAME}:${GIT_COMMIT}"

APP_ID="/${NAME}"
HAPROXY_VHOST=""

INSTANCE_RAM=64
INSTANCE_CPU=0.25
INSTANCE_DISK=0
INSTANCE_NUMBER=1

PMA_USER=""
PMA_HOST=""
PMA_PORT=""

cp -f marathon.json marathon.json.tmp

sed -i "s|__DOCKER_IMAGE_NAME__|${IMAGE_NAME}|g" marathon.json.tmp

sed -i "s|__APP_ID__|${APP_ID}|g" marathon.json.tmp
sed -i "s|__HAPROXY_VHOST__|${HAPROXY_VHOST}|g" marathon.json.tmp
sed -i "s|__INSTANCE_RAM__|${INSTANCE_RAM}|g" marathon.json.tmp
sed -i "s|__INSTANCE_CPU__|${INSTANCE_CPU}|g" marathon.json.tmp
sed -i "s|__INSTANCE_DISK__|${INSTANCE_DISK}|g" marathon.json.tmp
sed -i "s|__INSTANCE_NUMBER__|${INSTANCE_NUMBER}|g" marathon.json.tmp

sed -i "s|__PMA_USER__|${PMA_USER}|g" marathon.json.tmp
sed -i "s|__PMA_PASSWORD__|${database_password}|g" marathon.json.tmp
sed -i "s|__PMA_HOST__|${PMA_HOST}|g" marathon.json.tmp
sed -i "s|__PMA_PORT__|${PMA_PORT}|g" marathon.json.tmp

rm marathon.json
mv marathon.json.tmp marathon.json

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
docker build -t ${IMAGE_NAME} `pwd -P`
docker push ${IMAGE_NAME}


curl -X PUT -H "Content-type: application/json" -u admin:${MARATHON_PASSWORD} -d @marathon.json "http://datacenter.com:8080/v2/apps?force=true"