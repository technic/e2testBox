#!/bin/bash

set -ex
whoami

# default ubuntu box is too heavy
sudo apt-get -y remove --purge acpid lvm2 irqbalance mdadm open-iscsi lxd lxcfs snapd cloud-init
sudo apt-get -y autoremove
sudo systemctl disable accounts-daemon.service apparmor.service polkitd.service ufw.service

# autologin

user=$(id -nu 1000)
path="/etc/systemd/system/getty@tty1.service.d"

mkdir -p "$path"
cat > "$path/override.conf" <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $user --noclear %I \$TERM
EOF

apt-get update
apt-get install -y \
  virtualbox-guest-x11 virtualbox-guest-dkms \
  menu openbox xinit xterm gdb htop rsync

