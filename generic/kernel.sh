#!/usr/bin/env bash

PARAMS="mitigations=off hugepagesz=1GB hugepages=3 hugepagesz=2MB hugepages=8"
PATH=/etc/default/grub.d/50-cloudimg-settings.cfg

install() {
  sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $PARAMS\"/g" 
  sudo update-grub
  echo "Kernel: Installed"
}

remove() {
  echo "Kernel: Cannot remove"
}

if [ "$1" = "install" ]; then
  install >&2
  echo "Kernel: Installed" >&2
elif [ "$1" = "remove" ]; then 
  remove >&2
  echo "Kernel: Removed" >&2
elif ! grep "$PARAMS" "$PATH"; then
  echo "Kernel: Already installed" >&2
else
  install >&2
  echo "Kernel: Autoinstalling" >&2
fi
