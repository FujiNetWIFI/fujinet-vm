#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml 

FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$FN_PATH/FujiNet-PC-Atari"
mkdir -p "$INSTALL_PATH"
cd "$FN_PATH"

git clone https://github.com/FujiNetWIFI/fujinet-platformio

FNPIO_PATH="$FN_PATH/fujinet-platformio"
mkdir -p "$FNPIO_PATH/build"
cd "$FNPIO_PATH"

./build.sh -cp ATARI

rsync -au "$FNPIO_PATH/build/dist/" "$INSTALL_PATH/"

# Temporary fix to shebang to support functions - BK 2024-02-05
sed -i 's@#!/bin/sh@!#/usr/bin/env bash@' "$INSTALL_PATH/run-fujinet"

cat <<EOF | sudo tee /etc/systemd/system/fn-pc-atari.service 
[Unit]
Description=FujiNet PC for Atari
After=remote-fs.target
After=syslog.target
Requires = fn-emulator-bridge.service

[Service]
WorkingDirectory=$INSTALL_PATH
User=$P_USERNAME
Group=$P_USERNAME
ExecStart=$INSTALL_PATH/run-fujinet -u 0.0.0.0:8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable fn-pc-atari.service