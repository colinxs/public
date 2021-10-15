#!/usr/bin/env bash

if ! command -v docker; then
  # Older versions of Docker were called docker, docker.io, or docker-engine. If these are installed, uninstall them:
  sudo apt-get remove docker docker-engine docker.io containerd runc -y

  # Update the apt package index and install packages to allow apt to use a repository over HTTPS:
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

  # Add Docker’s official GPG key:
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg -y --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  # Use the following command to set up the stable repository
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

  sudo groupadd -f docker
  sudo usermod -aG docker $USER

  echo "Docker: Installed"
else
  echo "Docker: Already installed"
fi
