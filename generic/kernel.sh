PARAMS="mitigations=off hugepagesz=1GB hugepages=3 hugepagesz=2MB hugepages=8"
PATH=/etc/default/grub.d/50-cloudimg-settings.cfg

if ! grep "$PARAMS" "$PATH"; then
  sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $PARAMS\"/g" 
  sudo update-grub
  echo "Kernel: Installed"
else
  echo "Kernel: Already installed"
fi

