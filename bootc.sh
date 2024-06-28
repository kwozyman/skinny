#!/bin/bash
mkdir -p output/
export MYKEY=$(cat ~/.ssh/id_rsa.pub)
cat config.toml.tmpl | envsubst >config.toml
podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v $(pwd)/config.toml:/config.toml \
    registry.redhat.io/rhel9/bootc-image-builder:latest \
    --type raw \
    --local \
    quay.io/iranzo/skinny:latest
