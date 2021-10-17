#!/usr/bin/env bash

set -ex

GPG_KEY_PATH="/usr/share/keyrings/docker-archive-keyring.gpg"
APT_SOURCE_PATH="/etc/apt/sources.list.d/docker.list"

install() {
  sudo rm -f "$GPG_KEY_PATH"
  sudo rm -f "$APT_SOURCE_PATH"

  # Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
  for pkg in docker docker-engine docker.io containerd runc; do
    sudo apt purge -y --ignore-missing "$pkg" || true
  done

  # Update the apt package index and install packages to allow apt to use a repository over HTTPS:
  sudo apt update
  sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y

  # Add Docker’s official GPG key:
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o "$GPG_KEY_PATH"
  
  # Use the following command to set up the stable repository
  echo \
    "deb [arch=amd64 signed-by=$GPG_KEY_PATH] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee "$APT_SOURCE_PATH" > /dev/null

  # Install
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y --ignore-missing

  sudo groupadd -f docker
  sudo usermod -aG docker $USER
}

remove() {
  # Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
  for pkg in docker-ce docker-ce-cli containerd.io; do
    sudo apt purge -y --ignore-missing "$pkg" || true
  done
  
  sudo rm -f "$GPG_KEY_PATH"
  sudo rm -f "$APT_SOURCE_PATH"

  sudo gpasswd -d "$USER" docker || true
  sudo groupdel docker || true
}

if [ "$1" = "install" ]; then
  install >&2
  echo "Docker: Installed" >&2
elif [ "$1" = "remove" ]; then 
  remove >&2
  echo "Docker: Removed" >&2
elif command -v docker; then
  echo "Docker: Already installed" >&2
else
  install >&2
  echo "Docker: Autoinstalling" >&2
fi
