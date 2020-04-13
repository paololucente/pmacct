#!/usr/bin/env bash

BUILD_DOCKER_FILE=$1
BUILD_DOCKER_TAG=$2
BUILD_BRANCH=$3

docker build -f ${BUILD_DOCKER_FILE} -t ${BUILD_DOCKER_TAG} .

PWD=$(pwd)
echo "pwd:"${PWD}

CONTAINER_ID=$(docker run \
    --rm -it -d \
    -v ${PWD}:${PWD} \
    -w ${PWD} \
    ${BUILD_DOCKER_TAG}:latest)

echo "launched container id:" ${CONTAINER_ID}

docker exec -i ${CONTAINER_ID} bash -ex docker/build_inside.sh ${BUILD_BRANCH}

docker stop ${CONTAINER_ID}

cat -n docker/build_success.txt