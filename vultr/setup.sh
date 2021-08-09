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

# Create MBR partition table
parted $DRIVE -- mklabel msdos
# Create root partition
parted $DRIVE -- mkpart primary ${BOOT_MB}MiB -${SWAP_MB}MiB
# Create swap partition
parted $DRIVE -- mkpart primary linux-swap -${SWAP_MB}MiB 100%

# Format primary partition
mkfs.ext4 -L nixos ${DRIVE}1
# Format swap partition
mkswap -L swap ${DRIVE}2
# Activate swap
swapon ${DRIVE}2

# Mount target file system
mount /dev/disk/by-label/nixos /mnt

# Copy configuration
mkdir -p /mnt/etc/nixos
cp -f "${DIR}/configuration.nix" /mnt/etc/nixos
cp -f "${DIR}/configuration-core.nix" /mnt/etc/nixos

# Perform hardware scan
nixos-generate-config --root /mnt

# And install!
nixos-install --no-root-passwd
