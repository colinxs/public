eval "$(~/public/generic/nix.sh)"
eval "$(~/public/generic/docker.sh)"
eval "$(~/public/generic/service.sh)"

eval "$(~/public/generic/kernel.sh)"
sudo apt install linux-aws-edge -y
sudo shutdown -r now

if ! grep "access-tokens" /etc/nix/nix.conf; then
    echo "access-tokens = github.com=<TOKEN_HERE>" | sudo tee -a /etc/nix/nix.conf 
fi

