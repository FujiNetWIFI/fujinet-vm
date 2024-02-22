#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git build-essential curl cc65 default-jre

CODE_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
mkdir -p "$CODE_PATH"
cd "$CODE_PATH" || exit

git clone https://github.com/FujiNetWIFI/fujinet-apps

cd "$CODE_PATH/fujinet-apps/apple-tools" || exit
./mk-bitsy.sh clean.po CLEAN
