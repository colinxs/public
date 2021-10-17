#!/usr/bin/env bash 

DIR="$(dirname "$(realpath "$0")")"

find-init() {
  if [ -f /etc/profile.d/nix.sh ]; then
    echo /etc/profile.d/nix.sh
  else
    echo /etc/profile/nix.sh
  fi
}

install() {
  sudo apt install -y rsync
  yes | curl -L https://nixos.org/nix/install | sh -s -- --daemon

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
  
  nix-channel --add https://nixos.org/channels/nixos-unstable
  nix-channel --update

  nix-env -iA nixpkgs.nix_2_4 || nix-env -iA nixpkgs.nixUnstable

  nix store optimise
  
  source "$(find-init)"
}

remove() {
  sudo rm -rf \
      /etc/profile/nix.sh \
      /etc/profile/nix.sh.backup-before-nix \
      /etc/profile.d/nix.sh \
      /etc/profile.d/nix.sh.backup-before-nix \
      /etc/nix \
      /nix \
      ~root/.nix-profile \
      ~root/.nix-defexpr \
      ~root/.nix-channels \
      ~/.nix-profile \
      ~/.nix-defexpr \
      ~/.nix-channels

  # If you are on Linux with systemd, you will need to run:
  sudo systemctl stop nix-daemon.socket
  sudo systemctl stop nix-daemon.service
  sudo systemctl disable nix-daemon.socket
  sudo systemctl disable nix-daemon.service
  sudo systemctl daemon-reload
}

finish() {
  echo "source $(find-init)"
}

source "$(find-init)" >&2
if [ "$1" = "install" ]; then
  install >&2
  echo "Nix: Installed" >&2
  finish
elif [ "$1" = "remove" ]; then 
  remove >&2
  echo "Nix: Removed" >&2
elif command -v nix >/dev/null 2>&1; then
  echo "Nix: Already installed" >&2
  finish
else
  install >&2
  echo "Nix: Autoinstalled" >&2
  finish
fi
