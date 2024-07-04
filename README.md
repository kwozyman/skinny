# Skinny RHEL

Scripts for creating a reduced RHEL image via a container that is converted with [BOOTC](https://github.com/osbuild/bootc-image-builder#-image-types) into a bootable raw image

## Usage

| Script                    | Description                                              |
| ------------------------- | -------------------------------------------------------- |
| `./0-build.sh`            | To build the container using `ContainerFile`             |
| `./1-tag-and-push.sh $ID` | To push the image to quay repo                           |
| `./2-bootc.sh`            | To create RAW image in output/ folder with bootc support |
| `./3-resizedisk.sh`       | To resize disk so that it fits in a 4GB disk             |
