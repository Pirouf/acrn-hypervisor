#!/bin/bash

# helper script to build ACRN with docker

TOPDIR=$(git rev-parse --show-toplevel)
DOCKER=$(which docker)

if [ -z "${TOPDIR}" ]; then
    echo "Run $0 from inside git repository!"
    exit 1
fi

if [ -z "${DOCKER}" ]; then
    echo "Cannot find docker binary, please install!"
    exit 1
fi

pushd ${TOPDIR} >/dev/null

if [ ! -f debian/docker/Dockerfile ]; then
    echo "No Dockerfile available!"
    exit 1
fi

# use DOCKER_BUILD_PARAMS for additional flags, e.g. --no-cache
# defaults to -q
DOCKER_BUILD_PARAMS=${DOCKER_BUILD_PARAMS:--q}

set -e
${DOCKER} build -f debian/docker/Dockerfile -t acrn-hypervisor-build ${DOCKER_BUILD_PARAMS} debian/docker
${DOCKER} run --rm -u $(id -u):$(id -g) -v $(pwd):/acrn-hypervisor acrn-hypervisor-build $@

popd >/dev/null
