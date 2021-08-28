#!/usr/bin/env bash

# Run with:
# nix-shell -p git --command "git clone https://github.com/colinxs/public.git && sudo ./public/vultr/setup.sh"

set -ev

SERVER_NAME="$1"
if [ -z "$SERVER_NAME" ]; then
    echo "You forgot the server name"
    exit
fi

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

# Perform hardware scan
rm -f "${DIR}/config/${SERVER_NAME}/hardware-configuration.nix"
nixos-generate-config --root /mnt --dir "${DIR}/config/${SERVER_NAME}" 

# And install!
nixos-install --no-root-passwd --flake "${DIR}/config/${SERVER_NAME}"

# Clone to user account and replace with flake config using the mounted paths
