#!/usr/bin/env bash

GITHUB_TOKEN=""
export GITHUB_TOKEN

set -ex
set +o noclobber

sudo apt update
sudo apt install coreutils msr-tools vim git -y

git -C ~/public pull || git clone https://github.com/colinxs/public.git ~/public
. ~/public/aws/main-stub.sh

