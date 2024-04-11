#!/bin/bash
echo "##########################"
echo "		Git Tools Kit		"
echo "##########################"
#echo "Please input repo address:"
#read gitrepo
#echo "Git Repo is:"
#echo $gitrepo
if [[ `git config -l |grep user.name=imxieke` == "" ]]; then
	echo "Start Set Git global infomation"
	git config --global user.name "imxieke"
	git config --global user.email "imxieke@qq.com"
	echo "set git config success!"
fi
echo "*****************************************"
#echo "Start pull repository"
#git pull
echo "Start Trace File"
git add -A
echo "Start commit"
git commit -m "Auto Update By Git-ToolKit"
echo "Start push"
git push
echo "Push success"