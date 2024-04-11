#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8
export LC_ALL=C

GREENCOLOR='\033[1;32m'
YELLOWCOLOR='\033[1;33m'
NC='\033[0m'

function black()
{
	echo -e "\033[30m $1 ${NC}"
}

function red()
{
	echo -e "\033[31m $1 ${NC}"
}

function green()
{
	echo -e "\033[32m $1 ${NC}"
}

function yellow()
{
	echo -e "\033[33m $1 ${NC}"
}

function blue()
{
	echo -e "\033[34m $1 ${NC}"
}

function purple()
{
	echo -e "\033[35m $1 ${NC}"
}

function skyblue()
{
	echo -e "\033[36m $1 ${NC}"
}

function white()
{
	echo -e "\033[37m $1 ${NC}"
}

function black_bg_white()
{
	echo -e "\033[40;37m $1 \033[0m"
}

function red_bg_white()
{
	echo -e "\033[41;37m $1 \033[0m"
}

function green_bg_white()
{
	echo -e "\033[42;37m $1 \033[0m"
}

function yellow_bg_white()
{
	echo -e "\033[43;37m $1 \033[0m"
}

function blue_bg_white()
{
	echo -e "\033[44;37m $1 \033[0m"
}

function purple_bg_white()
{
	echo -e "\033[45;37m $1 \033[0m"
}

function skyblue_bg_white()
{
	echo -e "\033[46;37m $1 \033[0m"
}

function white_bg_black()
{
	echo -e "\033[47;37m $1 \033[0m"
}

black "hello World"
red "hello World"
yellow "hello World"
blue "hello World"
green "hello World"
purple "hello World"
skyblue "hello World"
white "hello World"

black_bg_white "hello World"
red_bg_white "hello World"
green_bg_white "hello World"
blue_bg_white "hello World"
yellow_bg_white "hello World"
purple_bg_white "hello World"
skyblue_bg_white "hello World"
white_bg_black "hello World"
