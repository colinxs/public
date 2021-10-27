#!/usr/bin/env bash

RUN_SCRIPT=/opt/run.sh

sudo tee -a "$RUN_SCRIPT" > /dev/null <<EOF
#!/usr/bin/env bash
export CXS_DEBUG=1
export MACHINE=aws1
export HOME=/home/ubuntu/
docker container ps -qa | xargs docker container stop
docker container ps -qa | xargs docker container rm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
$(command -v nix) run 'github:colinxs/bigdata#main'
EOF
chmod a+x "$RUN_SCRIPT"

sudo tee -a /etc/systemd/system/project.service > /dev/null <<EOF
[Install]
WantedBy=multi-user.target

[Service]
ExecStart=$RUN_SCRIPT

[Unit]
After=network-online.target
After=NetworkManager.service
After=systemd-resolved.service
Wants=network.target
EOF

{ systemctl daemon-reload;
  systemctl disable project.service;
  systemctl stop project.service;
  systemctl enable project.service;
  systemctl start project.service;  #TODO(urgent)
} > /dev/null
