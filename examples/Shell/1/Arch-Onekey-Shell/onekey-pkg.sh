#!/usr/bin/env bash
case $1 in
	compile )
		sudo pacman -S  --noconfirm gcc make cmake pkg-config automake autoconf gettext yajl
		;;

	base-tools)
		sudo pacman -S --noconfirm zsh vim git curl wget procps net-tools
		;;
	
	zsh)
		git clone https://git.oschina.net/imxieke/oh-my-zsh.git ~/.oh-my-zsh
		cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
		zsh
		;;

	update)
		sudo pacman -Syyu --noconfirm
		;;
		
	*)
		echo  "Command Error！"
		;;
esac