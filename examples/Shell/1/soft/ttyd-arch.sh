#!/bin/bash
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games"
export PATH

pacman -Syyu --noconfirm
pacman -S --noconfirm wget curl git gcc make cmake vim pkg-config libwebsockets json-c 
git clone --depth=1 https://git.coding.net/tsl0922/ttyd.git ~/tmp/ttyd
git clone --depth=1 https://github.com/warmcat/libwebsockets.git ~/tmp/libwebsockets

mkdir -p ~/tmp && cd ~/tmp && wget https://code.aliyun.com/imxieke/pkgs/raw/master/main/libwebsockets-2.1.1.zip 
unzip libwebsockets-2.1.1.zip
mkdir -p ~/tmp/libwebsockets-2.1.1/build && cd ~/tmp/libwebsockets-2.1.1/build
cmake .. && make && make install && ln -s /usr/local/lib/libwebsockets.a /usr/lib/libwebsockets.a

cd ~/tmp/libwebsockets && cmake . && make && make install
mkdir -p ~/tmp/ttyd/build