#!/bin/bash
mkdir -p output/
export MYKEY=$(cat ~/.ssh/id_rsa.pub)

# CentOS builder
IMAGE="quay.io/centos-bootc/bootc-image-builder:latest"

# We use CentOS builder as the one in RHEL is missing the --rootfs parameter that
# we need to set the system to ext4 until we've a way to specify the disk size

podman run \
    --rm \
    -it \
    --privileged \
    --pull=always \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v $(pwd)/config.toml:/config.toml \
    ${IMAGE} \
    --type anaconda-iso \
    --local \
    quay.io/iranzo/skinny:latest
