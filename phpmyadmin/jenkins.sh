# SECRETS :
# DOCKER_USERNAME
# DOCKER_PASSWORD
# MARATHON_USER
# MARATHON_PASSWORD
# DATACENTER_URL
# HAPROXY_VHOST

# VARS :
# PMA_HOST
# PMA_PORT

#--------------------------------------------------------

cd ${JOB_NAME}

IMAGE_NAME="${DOCKER_USERNAME}/${JOB_NAME}:${GIT_COMMIT}"

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
docker build -t ${IMAGE_NAME} `pwd -P`
docker push ${IMAGE_NAME}

#--------------------------------------------------------

cd ${JOB_NAME}

APP_ID="/${JOB_NAME}"
IMAGE_NAME="${DOCKER_USERNAME}/${JOB_NAME}:${GIT_COMMIT}"

PMA_HOST="192.168.0.20"
PMA_PORT="3306"

INSTANCE_RAM=64
INSTANCE_CPU=0.25
INSTANCE_DISK=0
INSTANCE_NUMBER=1

sed -i "s|__DOCKER_IMAGE_NAME__|${IMAGE_NAME}|g" marathon.json
sed -i "s|__APP_ID__|${APP_ID}|g" marathon.json
sed -i "s|__HAPROXY_VHOST__|${HAPROXY_VHOST}|g" marathon.json
sed -i "s|__PMA_HOST__|${PMA_HOST}|g" marathon.json
sed -i "s|__PMA_PORT__|${PMA_PORT}|g" marathon.json

curl -X PUT -H "Content-type: application/json" -u ${MARATHON_USER}:${MARATHON_PASSWORD} -d @marathon.json "http://${DATACENTER_URL}/v2/apps?force=true"