#!/bin/bash
DIRNAME=`dirname $0`
DOCKER_BUILD_DIR=`cd $DIRNAME/; pwd`
echo "DOCKER_BUILD_DIR=${DOCKER_BUILD_DIR}"
cd ${DOCKER_BUILD_DIR}

BUILD_ARGS="--no-cache"
VERSION="0.0.1"
PROJECT="tools"
IMAGE="nginx-proxy"
DOCKER_REPOSITORY="registry.baidubce.com"
IMAGE_NAME="${DOCKER_REPOSITORY}/${PROJECT}/${IMAGE}"
TIMESTAMP=$(date +"%Y%m%dT%H%M%S")

BUILD_ARGS+=" --build-arg PKG_VERSION=${VERSION}"

if [ $HTTP_PROXY ]; then
    BUILD_ARGS+=" --build-arg HTTP_PROXY=${HTTP_PROXY}"
fi
if [ $HTTPS_PROXY ]; then
    BUILD_ARGS+=" --build-arg HTTPS_PROXY=${HTTPS_PROXY}"
fi

function build_image {
    echo "Start build docker image: ${IMAGE_NAME}"
    docker build ${BUILD_ARGS} -t ${IMAGE_NAME}:latest .
}

function push_image_tag {
    TAG_NAME=$1
    echo "Start push ${TAG_NAME}"
    docker tag ${IMAGE_NAME}:latest ${TAG_NAME}
    docker push ${TAG_NAME}
}

function push_image {
    echo "Start push ${IMAGE_NAME}:latest"
    docker push ${IMAGE_NAME}:latest
    
    push_image_tag ${IMAGE_NAME}:${VERSION}-SNAPSHOT-latest
    push_image_tag ${IMAGE_NAME}:${VERSION}-STAGING-latest
    push_image_tag ${IMAGE_NAME}:${VERSION}-STAGING-${TIMESTAMP}
}

build_image
push_image
