#!/usr/bin/env bash 

set -ex

DIR="$(dirname "$(realpath "$0")")"

install() {
  sudo apt install -y rsync
  yes | curl -L https://nixos.org/nix/install | sh -s -- --daemon

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
  " > "${HOME}/.config/nix/nix.conf"

  sudo systemctl restart nix-daemon

  nix store optimise
}

remove() {
  sudo rm -rf /etc/profile/nix.sh /etc/nix /nix ~root/.nix-profile ~root/.nix-defexpr ~root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

  # If you are on Linux with systemd, you will need to run:
  sudo systemctl stop nix-daemon.socket
  sudo systemctl stop nix-daemon.service
  sudo systemctl disable nix-daemon.socket
  sudo systemctl disable nix-daemon.service
  sudo systemctl daemon-reload
}

if [ -f /etc/profile.d/nix.sh ]; then
  . /etc/profile.d/nix.sh
fi

if [ "$1" = "install" ]; then
  install
  echo "Nix: Installed"
elif [ "$1" = "remove" ]; then 
  remove
  echo "Nix: Removed"
elif command -v nix; then
  echo "Nix: Already installed"
else
  install
  echo "Nix: Autoinstalling"
fi
