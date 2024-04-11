#!/usr/bin/env bash

[[ "$(id -u)" == 0 ]] || echo "switch root user or use sudo" && exit 1

echo "Asia/Shanghai" > /etc/timezone
rm -fr /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime