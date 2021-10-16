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
  install
  echo "Kernel: Installed"
elif [ "$1" = "remove" ]; then 
  remove
  echo "Kernel: Removed"
elif ! grep "$PARAMS" "$PATH"; then
  echo "Kernel: Already installed"
else
  install
  echo "Kernel: Autoinstalling"
fi
