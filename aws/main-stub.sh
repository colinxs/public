eval "$(~/public/generic/nix.sh)"
eval "$(~/public/generic/docker.sh)"
eval "$(~/public/generic/service.sh)"

# TODO
# eval "$(~/public/generic/kernel.sh)"
# if ! apt list --installed | grep "linux-aws-edge"; then
#     sudo apt install linux-aws-edge -y
#     sudo shutdown -r now
# fi

if ! grep "access-tokens" /etc/nix/nix.conf; then
    echo "access-tokens = github.com=<TOKEN_HERE>" | sudo tee -a /etc/nix/nix.conf 
fi

