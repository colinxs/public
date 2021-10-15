sudo apt update
sudo apt install msr-tools vim git -y
git -C ~/public pull || git clone https://github.com/colinxs/public.git ~/public
~/public/generic/nix.sh
~/public/generic/docker.sh
~/public/generic/kernel.sh
~/public/aws/main.sh
CXS_DEBUG=1 MACHINE=aws1 "$(which nix)" run 'github:colinxs/bigdata#main'

