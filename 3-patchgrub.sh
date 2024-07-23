#!/bin/bash

# FIND Empty loopback device
FREE=$(losetup -f)

MYDISK=output/image/disk.raw

echo "Preparing disk image to be available via ${FREE} device"
losetup ${FREE} ${MYDISK}

echo "Finding partitions on ${FREE}"
partprobe ${FREE}

echo "Our target partition will be the 4th one"
TARGET=${FREE}p4
TARGETBOOT=${FREE}p3

echo "Mounting filesystems"
mount ${TARGET} /mnt/
mount ${TARGETBOOT} /mnt/boot

echo "Obtaining boot data"
export MYCONFIG="/mnt/boot/loader.1/entries/ostree-1.conf"
export MYCONFIGTGT="/mnt/boot/grub2/grub.cfg"

[[ ! -f ${MYCONFIG} ]] && echo "ERROR: File ${MYCONFIG} not found" && exit 1
[[ ! -f ${MYCONFIGTGT} ]] && echo "ERROR: File ${MYCONFIGTGT} not found" && exit 1

export KERNEL=$(cat ${MYCONFIG} | grep ^linux | awk '{print $2}' | sed 's#/boot##g')
export INITRD=$(cat ${MYCONFIG} | grep ^initrd | awk '{print $2}' | sed 's#/boot##g')
export OPTIONS=$(cat ${MYCONFIG} | grep ^options | cut -d ' ' -f 2-)
export UUID=$(echo ${OPTIONS} | tr ' ' '\n' | grep root= | cut -d "=" -f 3-)

if [[ -n ${KERNEL} ]] || [[ -n ${INITRD} ]] || [[ -n ${OPTIONS} ]] || [[ -n ${UUID} ]]; then

    echo "Adding grub stanza"
    envsubst <grub2stanza.tmpl.cfg >>${MYCONFIGTGT}

    echo "Removing blscfg entry"
    sed -i 's#^blscfg##' ${MYCONFIGTGT}
    rm -fv ${MYCONFIG}

    echo "unmounting filesystems"

    umount ${TARGETBOOT} /mnt/boot
    umount ${TARGET} /mnt/

    echo "Disabling loopback device"
    losetup -d ${FREE}
else
    echo "Some variables couldn't be filled, check:"
    echo "KERNEL: ${KERNEL}"
    echo "INITRD: ${INITRD}"
    echo "OPTIONS: ${OPTIONS}"
    echo "UUID: ${UUID}"
    echo
    echo "Leaving disks mounted for debugging $MYCONFIG"
fi
