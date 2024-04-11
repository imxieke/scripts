#!/usr/bin/env bash
	Install(){
		apt-get install cmake g++ pkg-config git vim-common libwebsockets-dev libjson-c-dev libssl-dev
		git clone --depth=1 https://git.coding.net/tsl0922/ttyd.git /tmp/ttyd
		cd /tmp/ttyd
		mkdir -p /tmp/ttyd/build && cd /tmp/ttyd/build
		cmake .. && make && make install
	}