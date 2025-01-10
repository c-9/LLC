#!/bin/bash
# KERNEL="./arch/x86_64/boot/bzImage"
# ROOTFS="./rootfs.img"

KERNEL="/boot/vmlinuz-5.1.0-rc4"
INITRD="/boot/initrd.img-5.1.0-rc4"
ROOTFS="/home/zjq/chunk/git/git-own/blob/rootfs.img"
qemu-system-x86_64 \
    -kernel $KERNEL \
    -initrd $INITRD \
    -nographic \
    -drive file=$ROOTFS,format=raw \
    -append "root=/dev/sda init=/sbin/init console=ttyS0 nokaslr" \
    -s -S \
    -m 2G \
    -smp 2