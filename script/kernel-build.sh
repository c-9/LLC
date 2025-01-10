#!/bin/bash
# Comprehensive Linux Kernel Build Guide
# This guide follows kernel development best practices

# # 1. Set up build environment and install dependencies
# sudo apt update
# sudo apt install -y build-essential libncurses-dev gawk flex bison \
#     openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev \
#     libiberty-dev autoconf llvm git bc rsync cpio python3-pip \
#     libncurses5 libncurses5-dev libncursesw5 linux-firmware

# # 4. Set up environment variables for optimal build
# export ARCH=$(uname -m | sed 's/x86_64/x86/g')
# # Use all available CPU cores for compilation
# export MAKEFLAGS="-j$(nproc)"

CC="gcc-9"
CXX="g++-9"

sudo rm -rf /boot/*.old
sudo rm -rf /boot/initrd.img-$kernel_version
sudo rm -rf /boot/vmlinuz-$kernel_version

# # Enable compiler cache if available
# which ccache >/dev/null && export CC="ccache gcc"

# 5. Clean build environment
# make mrproper
make distclean

# 6. Create initial configuration
# Option 1: Based on current config
# cp /boot/config-$(uname -r) .config
cp /boot/config-5.1.0-050100-generic .config

scripts/config --set-val CONFIG_SYSTEM_TRUSTED_KEYS ""
scripts/config --set-val CONFIG_SYSTEM_REVOCATION_KEYS ""
yes '' | make oldconfig
# yes '' | make localmodconfig
# yes '' | make localyesconfig

kernel_version=$(make kernelrelease)
if [ -z "$kernel_version" ]; then
    kernel_version='5.1.0-rc4'
fi

# # Option 2: Default config with local version
# make defconfig
# scripts/config --set-str LOCALVERSION "-custom"

# # 7. Menuconfig for custom settings
# make menuconfig

# 8. Prepare for compilation
# Prepare modules and scripts
make WERROR=0 prepare && make WERROR=0 scripts

# # 9. Build kernel and modules
KCFLAGS="-fcf-protection=none"
# KCFLAGS=""
# make HOSTCC="gcc-9" CC="gcc-9" WERROR=0 KCFLAGS="-fcf-protection=none" all -j $(nproc)
# make HOSTCC="gcc-9" CC="gcc-9" WERROR=0 KCFLAGS="-fcf-protection=none" modules -j $(nproc)
make HOSTCC=$CC CC=$CC WERROR=0 KCFLAGS=$KCFLAGS all -j $(nproc)
make HOSTCC=$CC CC=$CC WERROR=0 KCFLAGS=$KCFLAGS modules -j $(nproc)

# # 10. Install kernel and modules
# sudo make HOSTCC="gcc-9" CC="gcc-9" WERROR=0 KCFLAGS="-fcf-protection=none" modules_install -j $(nproc)
# sudo make HOSTCC="gcc-9" CC="gcc-9" WERROR=0 KCFLAGS="-fcf-protection=none" install -j $(nproc)
sudo make HOSTCC=$CC CC=$CC WERROR=0 KCFLAGS=$KCFLAGS modules_install -j $(nproc)
sudo make HOSTCC=$CC CC=$CC WERROR=0 KCFLAGS=$KCFLAGS install -j $(nproc)

# # 11. Update bootloader (example for GRUB)
# sudo update-initramfs -c -k $(make kernelrelease)
# sudo update-grub

# # 12. Optional: Package the kernel (Debian/Ubuntu)
# make bindeb-pkg

# # 13. Clean up
# make clean

# mkdir -p boot
# sudo mkinitramfs -o boot/initrd.img-$(make kernelrelease)
# cp arch/x86/boot/bzImage boot/vmlinuz-$(make kernelrelease)
# cp System.map boot/System.map-$(make kernelrelease)
# cp .config boot/config-$(make kernelrelease)

sudo update-grub
