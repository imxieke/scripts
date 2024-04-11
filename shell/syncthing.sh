#!/usr/bin/env bash
# Syncthing Onekey Installer

mkdir -p /data/syncthing/{home,data} /opt/syncthing

VER='1.25.0'
PKG_URL="https://github.com/syncthing/syncthing/releases/download/v${VER}/syncthing-linux-amd64-v${VER}.tar.gz"

wget -sc ${PKG_URL} -O /tmp/syncthing-${VER}.tar.gz
tar -xvf 