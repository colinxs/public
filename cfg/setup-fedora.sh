#!/usr/bin/env bash
#

set -e

install() {
	sudo dnf install -y "$@"
}

firewall-add() {
	for s in "$@"; do
		sudo firewall-cmd --permanent --add-service="$s" 
	done
	sudo firewall-cmd --reload
}

enable-service() {
	sudo systemctl daemon-reload && sudo systemctl enable --now "$@"
}


# Util
install util-linux-user ripgrep fd-find gparted htop

# Kernel
sudo grubby --update-kernel ALL \
	--args "intel_iommu=on amd_iommu=on iommu=pt mitigations=off selinux=0" \
        --remove-args "rhgb quiet"
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Sudo
read -p "Add to /etc/sudoers: 'Defaults timestamp_timeout=60'"

# Shell
install zsh
# chsh -s "$(which zsh)"

sudo dnf group install -y \
	'Administration Tools' \
	'Container Management' \
	'Domain Membership' \
	'Headless Management' \
	'Network Servers' \
	'System Tools'

install firewall-config
firewall-add mdns dhcpv6-client dns http http3 https

# Pop Shell
install gnome-shell-extension-pop-shell


cat <<EOF | sudo tee /etc/cockpit/cockpit.conf
[WebService]
Origins =  http://localhost http://$(hostname) http://$(hostname).home.arpa http://$(hostname).cat-coho.ts.net http://$(hostname).lyres.org https://localhost https://$(hostname) https://$(hostname).home.arpa https://$(hostname).cat-coho.ts.net https://$(hostname).lyres.org gparted
ProtocolHeader = X-Forwarded-Proto
EOF
read -p "Edit cockpit port to 80 or 443 in cockpit.socket"
install \
	cockpit \
	cockpit-composer \
	cockpit-file-sharing \
	cockpit-kdump \
	cockpit-machines \
	cockpit-navigator \
	cockpit-networkmanager \
	cockpit-packagekit \
	cockpit-pcp \
	cockpit-podman \
	cockpit-selinux \
	cockpit-session-recording \
	cockpit-storaged \
	cockpit-system
firewall-add cockpit
enable-service cockpit.socket

install neovim

install mosh
firewall-add mosh

install git
sudo git config --global init.defaultBranch main
git config --global init.defaultBranch main

sudo rpm --import https://kopia.io/signing-key
cat <<EOF | sudo tee /etc/yum.repos.d/kopia.repo
[Kopia]
name=Kopia
baseurl=http://packages.kopia.io/rpm/stable/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://kopia.io/signing-key
EOF
install kopia kopia-ui
sudo mkdir -p /var/cache/kopia
sudo mkdir -p /var/log/kopia
cat <<EOF | sudo tee /etc/systemd/system/kopia.service
[Unit]
Description=Kopia Server
After=syslog.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/kopia server \
	--log-dir=/var/log/kopia \
	--cache-directory=/var/cache/kopia \
	--content-cache-size-mb=$((256 * 1024)) \
	--metadata-cache-size-mb=$((32 * 1024)) \
	--tls-generate-cert \
	--tls-cert-file=/var/lib/kopia/server.cert \
	--tls-key-file=/var/lib/kopia/server.key \
	--address=0.0.0.0:51515 \
	--refresh-interval=60s \
	--insecure
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
WantedBy=graphical.target
# and adjust paths
EOF
enable-service kopia.service

sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
cat <<EOF | sudo tee /etc/yum.repos.d/1password.repo
[1password]
name="1Password Beta Channel"
baseurl=https://downloads.1password.com/linux/rpm/beta/\$basearch
enabled=1
gpgcheck=1
#repo_gpgcheck=1
gpgkey="https://downloads.1password.com/linux/keys/1password.asc"
EOF
install 1password 1password-cli

sudo dnf install etckeeper
sudo etckeeper init
(cd /etc && sudo git remote add origin "git@github.com:colinxs/$(hostname)-etc.git":)
sudo etckeeper commit "init"
(cd /etc && sudo git push --set-upstream origin main)
sudo systemctl enable --now etckeeper.timer


install tuned tuned-gtk
enable-service tuned.service


enable-service dnf-makecache.timer

# File Sharing
sudo mkdir -p /share
install samba wsdd
firewall-add \
	samba samba-dc samba-client \
	ws-discovery ws-discovery-client ws-discovery-tcp ws-discovery-udp
enable-service smb.service wsdd.service

#install https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2022.12.05-1.fedora.x86_64.rpm
#firewall-add dropbox-lansync

# File Management
install nemo

# Phone
install nautilus-gsconnect webextension-gsconnect nemo-gsconnect
firewall-add gsconnect

# Terminal
install gnome-console && sudo dnf remove gnome-terminal

# Virtual Machines
install virt-manager libvirt-daemon-kvm libvirt-daemon-lxc 

# Grafana Agent
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
install grafana-agent
enable-service grafana-agent
firewall-add prometheus-node-exporter

# Remote Access
firewall-add ssh rdp

# Syncthing
install syncthing 
firewall-add syncthing syncthing-gui
enable-service syncthing@root.service

# Must be last
sudo systemctl disable --now firewalld
