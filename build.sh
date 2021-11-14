#!/bin/bash
set -eu

## Podman version check
PODMAN_VERSION=`podman --version | awk '{print $3}'`
PODMAN_VERSION=`echo $PODMAN_VERSION | sed -e s/[\.]//g`
if [[ $PODMAN_VERSION -gt 340 ]]; then
    echo "Podman version is 3.4.0+"
else
    echo "Podman version is *not* 3.4.0+"
    exit 1
fi

## Buildah version check
BUILDAH_VERSION=`buildah --version | awk '{print $3}'`
BUILDAH_VERSION=`echo $BUILDAH_VERSION | sed -e s/[\.]//g`
if [[ $BUILDAH_VERSION -gt 1230 ]]; then
    echo "buildah version is 1.23.0+"
else
    echo "buildah version is *not* 1.23.0+"
    exit 1
fi

# Repository Login
echo "### login to docker.io ###"
podman login docker.io

echo "### login to quay.io ###"
podman login quay.io

REPO=docker.io/tnk4on/code-server
QUAY=quay.io/tnk4on/code-server

# Build and Create Manifest
podman manifest create ${REPO}:latest

for ARCH in amd64 arm64
do
    podman build -t ${REPO}:${ARCH} --build-arg ARCH=${ARCH} --arch=${ARCH} .
    podman manifest add ${REPO}:latest containers-storage:${REPO}:${ARCH}
    podman push ${REPO}:${ARCH} --format docker
done

# Push
## Docker.io
podman manifest push --all ${REPO}:latest docker://${REPO}:latest --format docker

### Quay.io
buildah tag ${REPO} ${QUAY}
podman manifest push --all ${REPO}:latest docker://${QUAY}:latest