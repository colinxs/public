sudo apt update
sudo apt install coreutils msr-tools vim git -y
git -C ~/public pull || git clone https://github.com/colinxs/public.git ~/public

set -ex

. ~/public/generic/nix.sh
nix-env -iA nixpkgs.nix_2_4 || nix-env -iA nixpkgs.nixUnstable

. ~/public/generic/docker.sh

. ~/public/generic/kernel.sh

# if ! apt list --installed | grep "linux-aws-edge"; then
#     sudo apt install linux-aws-edge
#     sudo shutdown -r now
# fi

CXS_DEBUG=1 MACHINE=aws1 "$(which nix)" run 'github:colinxs/bigdata#main'
