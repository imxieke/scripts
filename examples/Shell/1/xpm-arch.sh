#!/usr/bin/env bash

case $1 in
	install|-i|i )
		sudo pacman -S $2 $3 $4 $5 $6 $7 $8 $9		
		;;

	in|-in )
		sudo pacman -S --noconfirm $2 $3 $4 $5 $6 $7 $8 $9
		;;

	ic|-ic )
		sudo pacman -U  $2 $3 $4 $5 $6 $7 $8 $9
		;;

	icn|-icn )
		sudo pacman -U --noconfirm $2 $3 $4 $5 $6 $7 $8 $9
		;;

	search|-s|s )
		sudo pacman -Ss $2 $3 $4 $5 $6 $7 $8 $9		
		;;

	update|-u|u )
		sudo pacman -Syy $2 $3 $4 $5 $6 $7 $8 $9		
		;;

	upgrade|-U|U )
		sudo pacman -Syyu $2 $3 $4 $5 $6 $7 $8 $9
		;;

	remove|-r|r )
		sudo pacman -R $2 $3 $4 $5 $6 $7 $8 $9
		;;

	rd|-rd )
		sudo pacman -Rs $2 $3 $4 $5 $6 $7 $8 $9
		;;

	show )
		sudo pacman -Qi $2 $3 $4 $5 $6 $7 $8 $9
		;;

	list|-l|l )
		sudo pacman -Ql $2 $3 $4 $5 $6 $7 $8 $9
		;;

	down|-d|d )
		sudo pacman -Sw $2 $3 $4 $5 $6 $7 $8 $9
		;;

	clean|-c|c )
		sudo pacman -Sc $2 $3 $4 $5 $6 $7 $8 $9
		;;

	cleanall|-ca|ca )
		sudo pacman -Scs $2 $3 $4 $5 $6 $7 $8 $9
		;;

	* )
		echo $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 ""
		echo "Command Error, Input Again"
		;;




esac