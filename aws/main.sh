set -ex

sudo apt update
sudo apt install coreutils msr-tools vim git -y

git -C ~/public pull || git clone https://github.com/colinxs/public.git ~/public

eval "$(~/public/generic/nix.sh)"
eval "$(~/public/generic/docker.sh)"
eval "$(~/public/generic/kernel.sh)"

# TODO
# if ! apt list --installed | grep "linux-aws-edge"; then
#     sudo apt install linux-aws-edge
#     sudo shutdown -r now
# fi

CXS_DEBUG=1 MACHINE=aws1 "$(command -v nix)" run 'github:colinxs/bigdata#main'
