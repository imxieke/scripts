#!/bin/bash
#Depends:zsh wget curl python2.7+ ruby node npm 

echo "Xiekers ToolKit Script	"
echo "Author:Xiekers <im@xieke.org>"
echo "time:	Friday step 16 2016	   "
case $1 in
	bench)
		wget -qO- bench.sh | bash
		# wget -qO- 86.re/bench.sh | bash
		# curl -Lso- https://github.com/teddysun/across/raw/master/bench.sh | bash
		echo "Site:https://github.com/teddysun/across"
		;;

	unixbench)
		wget -qO- https://github.com/teddysun/across/raw/master/unixbench.sh | bash
		echo "Site:https://github.com/teddysun/across"
		;;

	clone )
		git clone https://github.com/$2/$3.git
		;;

	shadowsocks)
		# wget -qO- https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh | sudo bash | tee shadowsocks-all.log
		wget https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh 
		chmod +x shadowsocks-all.sh 
		./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
		;;

	setnpmrc)
		echo registry=https://npm.tuna.tsinghua.edu.cn >> ~/.npmrc
		echo "Set npm source Success!"
		;;

	setgems)
		gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
		gem sources -l
		echo "Gems Set Success!"
		;;

	speedtest-cli)
		wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
		echo "Installation complete"
		echo "Usage: speedtest-cli -h"
		echo "Site:https://github.com/sivel/speedtest-cli"
		;;

	zsh)
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		echo "Installation complete"
		echo "Usage:zsh"
		echo "Site:https://github.com/robbyrussell/oh-my-zsh"
		;;

	*)
		echo "Command Error!"
		;;
esac