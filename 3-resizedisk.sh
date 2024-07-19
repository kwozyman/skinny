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

echo "FSCK the filesystem prior to operation"
fsck -f ${TARGET}

echo "Resize FS to 990000 blocks"
resize2fs ${TARGET} 990000

echo "Alter partition size to 2,5Gb"
echo ", 2,5G" | sfdisk -N 4 ${FREE}

echo "Disable loopback"
losetup -d ${FREE}

echo "Cut device backing storage"
truncate ${MYDISK} --size 4G

# Fix Partition tables
echo "Fixing partition tables"
echo -e "w\ny\nq\n" | gdisk ${MYDISK}

# FIND Empty loopback device
FREE=$(losetup -f)
echo "Preparing disk image to be available via ${FREE} device"
losetup ${FREE} ${MYDISK}

echo "Finding partitions on ${FREE}"
partprobe ${FREE}

echo "Our target partition will be the 4h one"
TARGET=${FREE}p4

echo "Make our target partition to use the full disk"
echo ", +" | sfdisk -N 4 ${FREE}

echo "Resize FS to max partition size"
resize2fs ${TARGET}

echo "Disable loopback"
losetup -d ${FREE}
