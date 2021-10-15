set -ex

sudo apt install rsync

sudo rm -rf /etc/nix /nix /root/.nix-profile /root/.nix-defexpr /root/.nix-channels /home/$USER/.nix-profile /home/$USER/.nix-defexpr /home/$USER/.nix-channels /etc/profile.d/nix*

bash <(curl -L https://nixos.org/nix/install) --daemon

source /etc/profile.d/nix.sh

nix-env -iA nixpkgs.nixUnstable

sudo rm /etc/nix/nix.conf
echo \
"
build-users-group = nixbld 
trusted-users = root $USER 
log-lines = 200
cores = 0
max-jobs = auto
auto-optimise-store = true 
" | sudo tee /etc/nix/nix.conf

mkdir -p "${HOME}/.config/nix"
echo \
"
substituters = https://cache.nixos.org https://nix-community.cachix.org https://colinxs.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= colinxs.cachix.org-1:N5myc56TmJpz5qxu9tQ8RBUWMuwTtkXTyLmWVhzsIvk=
tarball-ttl = 0
experimental-features = nix-command flakes
access-tokens = github.com=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
" > "${HOME}/.config/nix/nix.conf"

sudo systemctl restart nix-daemon

nix store optimise
