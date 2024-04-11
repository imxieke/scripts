#!/usr/bin/env bash
pkg_name="proxychains-ng-4.11.tar.bz2"
echo "start install proxychains-ng-4"
wget https://dl.xieke.org/pkgs/src/$pkg_name && \
	tar -jxvf $pkg_name && cd proxychains-ng-4.11 && \
	mkdir -p ~/.proxychains && \ 
	wget https://dl.xieke.org/conf/proxychains.conf -O ~/.proxychains/proxychains.conf && \
	./configure --prefix=/usr --sysconfdir=/etc && \
	make && make install && \

echo "proxychains-ng-4 install success"
echo "please Change configuration file ~/.proxychains/proxychains.conf"