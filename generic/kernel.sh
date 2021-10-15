sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)*"/GRUB_CMDLINE_LINUX_DEFAULT="\1 mitigations=off hugepagesz=1GB hugepages=3 hugepagesz=2MB hugepages=8"/g' /etc/default/grub.d/50-cloudimg-settings.cfg
sudo update-grub

