# Skinny RHEL

Scripts for creating a reduced RHEL image via a container that is converted with [BOOTC](https://github.com/osbuild/bootc-image-builder#-image-types) into a bootable raw image

## Usage

- `./build.sh` # To build the container using `ContainerFile`
- `./tag-and-push.sh $ID` # To push the image to quay repo
- `./bootc.sh` # To create RAW image in output/ folder with bootc support
