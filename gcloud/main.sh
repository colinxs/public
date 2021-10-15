sudo apt update \
&& sudo apt install vim git -y \
&& git clone https://github.com/colinxs/public.git \
&& cd ~/public/gcloud/nix && ./setup.sh \
&& cd ~/public && ./docker.sh \
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)*"/GRUB_CMDLINE_LINUX_DEFAULT="\1 mitigations=off hugepagesz=1GB hugepages=3 hugepagesz=2MB hugepages=8"/g' /etc/default/grub.d/50-cloudimg-settings.cfg \
&& sudo update-grub \
&& sudo apt-get clean \
&& sudo shutdown -r now
