#!/usr/bin/env bash

set +o noclobber

script="$(mktemp)"
sudo tee "$script" > /dev/null <<EOF
export HOME=/home/ubuntu

set -ex
set +o noclobber

echo "USER: $(whoami)"
echo "HOME: ${HOME}"
echo "DIR: $(pwd)"

GITHUB_TOKEN=""
export GITHUB_TOKEN

sudo apt update
sudo apt install coreutils msr-tools vim git -y

git -C ~/public pull || git clone https://github.com/colinxs/public.git ~/public
. ~/public/aws/main-stub.sh
EOF

sudo -i -u ubuntu bash "$script"
