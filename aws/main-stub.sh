eval "$(~/public/generic/nix.sh)"
eval "$(~/public/generic/docker.sh)"
eval "$(~/public/generic/service.sh)"

if ! grep "access-tokens" /etc/nix/nix.conf; then
    echo "access-tokens = github.com=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" | sudo tee -a /etc/nix/nix.conf 
fi

eval "$(~/public/generic/kernel.sh)"
# sudo apt install linux-aws-edge -y
# sudo shutdown -r now

