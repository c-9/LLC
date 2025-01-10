#!/bin/bash
# Complete setup for kernel debugging with VSCode and QEMU

# 1. Install required packages
sudo apt update
sudo apt install -y build-essential gdb gcc make git flex bison \
    libncurses-dev libssl-dev libelf-dev qemu-system-x86 \
    qemu-utils bridge-utils

# 2. Install VSCode extensions (can be done via GUI too)
code --install-extension ms-vscode.cpptools
code --install-extension webfreak.debug

# 3. Set up kernel for debugging
cd ~/kernel-source
# Enable debug info and KGDB
scripts/config --enable DEBUG_INFO \
    --enable DEBUG_INFO_DWARF4 \
    --enable DEBUG_KERNEL \
    --enable KGDB \
    --enable KGDB_SERIAL_CONSOLE \
    --enable DEBUG_RODATA_TEST

# Build kernel with debug symbols
make -j$(nproc)

# 4. Create debug rootfs
mkdir -p ~/rootfs
cd ~/rootfs
# Create minimal initramfs with busybox
mkdir -p bin sbin etc proc sys usr/bin usr/sbin root
wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2
tar xf busybox-1.35.0.tar.bz2
cd busybox-1.35.0
make defconfig
# Enable static linking
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
make -j$(nproc)
make install
cd ..

# Create init script
cat >init <<'EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
echo "/sbin/mdev" > /proc/sys/kernel/hotplug
mdev -s
echo "Boot took $(cut -d' ' -f1 /proc/uptime) seconds"
exec /bin/sh
EOF
chmod +x init

# Create root filesystem image
find . | cpio -o -H newc | gzip >../rootfs.img

# 5. Create QEMU launch script
cat >~/run-kernel-debug.sh <<'EOF'
#!/bin/bash
KERNEL="./arch/x86_64/boot/bzImage"
ROOTFS="./rootfs.img"

qemu-system-x86_64 \
    -kernel $KERNEL \
    -initrd $ROOTFS \
    -append "console=ttyS0 nokaslr" \
    -nographic \
    -s -S \
    -m 2G \
    -smp 2
EOF
chmod +x ~/kernel-debug.sh

#6. Create disk image
DISK="~/chunk/git/git-own/blob/rootfs.img"
# dd if=/dev/zero of=$DISK bs=1G count=10
qemu-img create -f raw $DISK 20G
echo "o" | fdisk "$DISK"
echo "n" | fdisk "$DISK"
echo "p" | fdisk "$DISK" # Primary partition
echo "1" | fdisk "$DISK" # Partition number
echo "" | fdisk "$DISK"  # Use default start sector
echo "" | fdisk "$DISK"  # Use default end sector
echo "a" | fdisk "$DISK" # bootable
echo "w" | fdisk "$DISK"
sudo losetup -fP disk.img
sudo losetup -a | grep "disk.img"
sudo mkfs.ext4 /dev/loop6p1
sudo mkdir /mnt/disk && sudo mount /dev/loop6p1 /mnt/disk
sudo umount /mnt/disk
sudo losetup -d /dev/loop6

#7. another way to create rootfs
DISK="~/chunk/git/git-own/blob/rootfs.img"
dd if=/dev/zero of=$DISK bs=1G count=20
sudo losetup -fP rootfs.img
sudo mkfs.ext4 /dev/loop7
sudo mount /dev/loop7 /mnt/disk
# Option-1: Run debootstrap to install a minimal Debian-based system into the mounted root
sudo debootstrap --arch amd64 focal /mnt/disk http://archive.ubuntu.com/ubuntu/

# Option 2: Manually Create a Minimal System with BusyBox
sudo wget https://busybox.net/downloads/busybox-1.33.0.tar.bz2
sudo tar -xvjf busybox-1.33.0.tar.bz2
cd busybox-1.33.0
make defconfig
make
sudo make install
sudo mkdir -p /mnt/disk/{bin,etc,lib,proc,sys,tmp,usr}
cat >/mnt/disk/init <<'EOF'
#!/bin/sh
echo "Welcome to Minimal Linux!"
mount -t proc proc /proc
mount -t sysfs sysfs /sys
echo "System Ready"
/bin/sh
EOF
chmod +x /mnt/disk/init
cat >/mnt/disk/etc/fstab <<'EOF'
/dev/sda1 / ext4 defaults 0 1
EOF
sudo umount /mnt/disk
sudo losetup -d /dev/loop7