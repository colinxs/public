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
install util-linux-user ripgrep fd-find

# Kernel
sudo grubby --update-kernel ALL --args "intel_iommu=on amd_iommu=on iommu=pt mitigations=off selinux=0"
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Shell
install zsh
chsh -s "$(which zsh)"

sudo dnf group install -y \
	'Container Management' \
	'Headless Management' \
	'Network Servers'

install firewall-config
firewall-add mdns dhcpv6-client dns http http3 https

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
read -p "Edit cockpit port to 80 or 443 in cockpit.socket"
enable-service cockpit.socket

install neovim

install mosh
firewall-add mosh

install git
sudo git config --global init.defaultBranch main
git config --global init.defaultBranch main

sudo dnf install etckeeper
sudo etckeeper init
(cd /etc && sudo git remote add origin git@github.com:colinxs/goliath-etc.git)
sudo etckeeper commit "init"
(cd /etc && sudo git push --set-upstream origin main)
sudo systemctl enable --now etckeeper.timer

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

install tuned tuned-gtk
enable-service tuned

enable-service dnf-makecache.timer

cat <<EOF | sudo tee /etc/cockpit/cockpit.conf
[WebService]
AllowUnencrypted = true
Origins = http://localhost https://localhost https://$(hostname).lyres.org
ProtocolHeader = X-Forwarded-Proto
ForwardedForHeader = X-Forwarded-For
EOF

# File Sharing
sudo mkdir -p /share
install samba wsdd
firewall-add samba samba-dc samba-client wsdd wsdd-http ws-discovery ws-discovery-client ws-discovery-tcp ws-discovery-udp
enable-service smb.service wsdd.service

install https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2022.12.05-1.fedora.x86_64.rpm
firewall-add dropbox-lansync

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

install tigervnc-server
cat <<EOF | sudo tee /etc/systemd/system/vncserver@.service
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
ExecStartPre=+/usr/libexec/vncsession-restore %i
ExecStart=/sbin/runuser -l $USER -c "/usr/bin/vncserver %i -geometry 1920x1080"
PIDFile=/home/$USER/.vnc/%H%i.pid
SELinuxContext=system_u:system_r:vnc_session_t:s0

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
echo "Set VNC Pass:"
vncpasswd
enable-service vncserver@:0.service



