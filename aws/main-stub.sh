eval "$(~/public/generic/nix.sh)"
eval "$(~/public/generic/docker.sh)"
eval "$(~/public/generic/service.sh)"

if ! grep "access-tokens" /etc/nix/nix.conf; then
    echo "access-tokens = github.com=$GITHUB_TOKEN" | sudo tee -a /etc/nix/nix.conf 
fi

sudo apt install linux-aws-edge -y
eval "$(~/public/generic/kernel.sh)"
sudo shutdown -r now

