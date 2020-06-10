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
    echo "No Dockefile available!"
    exit 1
fi

set -e
${DOCKER} build -q -f debian/docker/Dockerfile -t acrn-hypervisor-build debian/docker
${DOCKER} run --rm -u $(id -u):$(id -g) -v $(pwd):/acrn-hypervisor acrn-hypervisor-build $@

popd >/dev/null
