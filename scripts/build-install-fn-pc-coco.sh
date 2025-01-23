#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml

FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$FN_PATH/FujiNet-PC-CoCo"
mkdir -p "$INSTALL_PATH"
cd "$FN_PATH" || exit
git clone https://github.com/FujiNetWIFI/fujinet-firmware

FNPIO_PATH="$FN_PATH/fujinet-firmware"
mkdir -p "$FNPIO_PATH/build"
cd "$FNPIO_PATH" || exit
git pull --rebase

./build.sh -cp COCO

rsync -au "$FNPIO_PATH/build/dist/" "$INSTALL_PATH/"

sed -i 's/devicename=/devicename=FujiNet-CoCo/' "$INSTALL_PATH/fnconfig.ini"

cat <<EOF | sudo tee /etc/systemd/system/fn-pc-coco.service 
[Unit]
Description=FujiNet PC for CoCo
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=$INSTALL_PATH
User=$P_USERNAME
Group=$P_USERNAME
ExecStart=$INSTALL_PATH/run-fujinet -u 0.0.0.0:8002
KillSignal=9
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable fn-pc-coco.service
