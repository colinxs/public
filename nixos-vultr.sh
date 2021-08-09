#!/usr/bin/env bash

DRIVE=/dev/vda

BOOT_MB=512

MIN_MEM_MB=4096
MEM_MB=$(free -m | awk '/^Mem:/{print $2}')
SWAP_MB=$([ $MEM_MB -lt $MIN_MEM_MB ] && echo $MIN_MEM_MB || echo $MEM_MB)

# Create GPT partition table
echo parted $DRIVE -- mklabel gpt

# Create swap partition
echo parted $DRIVE -- mkpart primary ${BOOT_MB}MiB -${SWAP_MB}MiB
echo parted $DRIVE -- mkpart primary linux-swap -${SWAP_MB}GiB 100%

# Create boot partition
parted $DRIVE -- mkpart ESP fat32 1MiB ${BOOT_MB}MiB
parted $DRIVE -- set 3 esp on

