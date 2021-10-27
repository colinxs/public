#!/usr/bin/env bash

shopt -s nullglob 

NR_HUGEPAGES_PER_NODE=1280
NR_1GB_PER_NODE=3

nodes=(/sys/devices/system/node/node*)
nnodes=''${#nodes[@]}
(( nr_1gbpages=nnodes * NR_1GB_PER_NODE ))
(( nr_hugepages=nnodes * NR_HUGEPAGES_PER_NODE ))

PARAMS="mitigations=off hugepagesz=1GB hugepages=${nr_1gbpages} hugepagesz=2MB hugepages=${nr_hugepages}"
GRUB_PATH="/etc/default/grub.d/50-cloudimg-settings.cfg"

install() {
  sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $PARAMS\"/g" "$GRUB_PATH"
  sudo update-grub
}

remove() {
  echo "Kernel: Cannot remove"
}

sudo apt -y install grep >&2
if [ "$1" = "install" ]; then
  install >&2
  echo "Kernel: Installed" >&2
elif [ "$1" = "remove" ]; then 
  remove >&2
  echo "Kernel: Removed" >&2
elif grep "$PARAMS" "$GRUB_PATH" > /dev/null; then
  echo "Kernel: Already installed" >&2
else
  install >&2
  echo "Kernel: Autoinstalling" >&2
fi
