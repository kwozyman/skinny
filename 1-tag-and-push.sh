#!/bin/bash
podman tag ${1} quay.io/iranzo/skinny:latest
podman push quay.io/iranzo/skinny:latest
