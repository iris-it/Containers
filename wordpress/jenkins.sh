#!/usr/bin/env bash

NAME="wordpress"
DOCKER_USERNAME="user"
DOCKER_PASSWORD="${REGISTRY_PASSWORD}"
IMAGE_NAME="${DOCKER_USERNAME}/${NAME}:${GIT_COMMIT}"

APP_ID="${NAME}"
HOST_PATH="/var/data/${NAME}"
HAPROXY_VHOST=""

INSTANCE_RAM=128
INSTANCE_CPU=0.5
INSTANCE_DISK=1024
INSTANCE_NUMBER=2

WORDPRESS_DB_NAME=""
WORDPRESS_DB_HOST=""
WORDPRESS_DB_USER=""


cp -f marathon.json marathon.json.tmp

sed -i "s|__DOCKER_IMAGE_NAME__|${IMAGE_NAME}|g" marathon.json.tmp

sed -i "s|__APP_ID__|${APP_ID}|g" marathon.json.tmp
sed -i "s|__HOST_PATH__|${HOST_PATH}|g" marathon.json.tmp
sed -i "s|__HAPROXY_VHOST__|${HAPROXY_VHOST}|g" marathon.json.tmp
sed -i "s|__INSTANCE_RAM__|${INSTANCE_RAM}|g" marathon.json.tmp
sed -i "s|__INSTANCE_CPU__|${INSTANCE_CPU}|g" marathon.json.tmp
sed -i "s|__INSTANCE_DISK__|${INSTANCE_DISK}|g" marathon.json.tmp
sed -i "s|__INSTANCE_NUMBER__|${INSTANCE_NUMBER}|g" marathon.json.tmp

sed -i "s|__WORDPRESS_DB_NAME__|${WORDPRESS_DB_NAME}|g" marathon.json.tmp
sed -i "s|__WORDPRESS_DB_HOST__|${WORDPRESS_DB_HOST}|g" marathon.json.tmp
sed -i "s|__WORDPRESS_DB_USER__|${WORDPRESS_DB_USER}|g" marathon.json.tmp
sed -i "s|__WORDPRESS_DB_PASSWORD__|${database_password}|g" marathon.json.tmp

rm marathon.json
mv marathon.json.tmp marathon.json

cd apache
docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
docker build -t ${IMAGE_NAME} `pwd -P`
docker push ${IMAGE_NAME}

curl -X PUT -H "Content-type: application/json" -u admin:${MARATHON_PASSWORD} -d @marathon.json "http://datacenter.com:8080/v2/apps?force=true"