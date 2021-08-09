#!/usr/bin/env bash

# Run with:
# cd "$(curl -s -L https://github.com/colinxs/public/archive/master.tar.gz | tar -xvz | head -1)" && sudo ./vultr/setup.sh

set -ev

DIR="$(dirname "$0")"

DRIVE=/dev/vda

BOOT_MB=512

MIN_MEM_MB=4096
MEM_MB=$(free -m | awk '/^Mem:/{print $2}')
SWAP_MB=$([ $MEM_MB -lt $MIN_MEM_MB ] && echo $MIN_MEM_MB || echo $MEM_MB)

# Create GPT partition table
parted $DRIVE -- mklabel gpt

# Create swap partition
parted $DRIVE -- mkpart primary ${BOOT_MB}MiB -${SWAP_MB}MiB
parted $DRIVE -- mkpart primary linux-swap -${SWAP_MB}MiB 100%

# Create boot partition (EFI ONLY)
# parted $DRIVE -- mkpart ESP fat32 1MiB ${BOOT_MB}MiB
# parted $DRIVE -- set 3 esp on

# Format primary partition
mkfs.ext4 -L nixos ${DRIVE}1
ls /dev/disk/by-label

# Create swap
mkswap -L swap ${DRIVE}2

# Format boot (EFI ONLY)
# mkfs.fat -F 32 -n boot ${DRIVE}3

# Mount target file system
mount /dev/disk/by-label/nixos /mnt

# Mount boot
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Activate swap
swapon ${DRIVE}2

mkdir -p /mnt/etc/nixos
cp -f "${DIR}/configuration.nix" /mnt/etc/nixos
cp -f "${DIR}/configuration-extra.nix" /mnt/etc/nixos

nixos-generate-config --root /mnt

nixos-install --no-root-passwd
