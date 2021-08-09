#!/usr/bin/env bash

# Run with:
# nix-shell -p git --command "git clone https://github.com/colinxs/public.git && sudo ./public/vultr/setup.sh"

set -ev

DIR="$(realpath "$(dirname "$0")")"

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
ln -s "${DIR}/config/configuration.nix" /mnt/etc/nixos/configuration.nix

# Perform hardware scan
# HACK
ln -s /mnt/etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
nixos-generate-config --root /mnt

# And install!
nixos-install --no-root-passwd

# Clone to user account and replace with flake config
# Using the mounted paths
mv ~/public /mnt/home/nixos
rm /mnt/etc/nix/configuration.nix
ln -s /home/nixos/public/vultr/config/flake.nix /mnt/etc/nix/flake.nix
