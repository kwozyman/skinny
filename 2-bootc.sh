#!/bin/bash
mkdir -p output/
export MYKEY=$(cat ~/.ssh/id_rsa.pub)
envsubst <config.tmpl.json >config.json

# RHEL one
IMAGE="registry.redhat.io/rhel9/bootc-image-builder:latest"

# CentOS builder
IMAGE="quay.io/centos-bootc/bootc-image-builder:latest"

# We use CentOS builder as the one in RHEL is missing the --rootfs parameter that
# we need to set the system to ext4 until we've a way to specify the disk size

# TODO: Switch back to RHEL builder once --rootfs is added
# TODO: Once we can determine the disk size created set it and default to whatever FS is used by the tool

podman run \
    --rm \
    -it \
    --privileged \
    --pull=always \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v $(pwd)/config.json:/config.json \
    ${IMAGE} \
    --rootfs ext4 --type raw \
    --local \
    quay.io/iranzo/skinny:latest
