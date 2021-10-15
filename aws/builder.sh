#!/usr/bin/env bash

sudo apt update
sudo apt install vim linux-aws-edge git -y
git clone https://github.com/colinxs/public.git ~/public
~/public/generic/nix.sh
~/public/generic/kernel.sh
sudo apt-get clean
sudo shutdown -r now
