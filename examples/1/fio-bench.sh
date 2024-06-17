#!/bin/bash
#
# [FIO Benchmark]
#
# GitHub:   https://github.com/amefs/fio-bench
# Author:   Amefs
# Current version:  v1.0.0
#################################################################################
EXTRACMD=${@:1}
################################################################################
# HELP FUNCTIONS
################################################################################
_norm=$(tput sgr0)
_red=$(tput setaf 1)
_green=$(tput setaf 2)
_tan=$(tput setaf 3)
_cyan=$(tput setaf 6)

function _print() {
    printf "${_norm}%s${_norm}\n" "$@"
}
function _info() {
    printf "${_cyan}➜ %s${_norm}\n" "$@"
}
function _success() {
    printf "${_green}✓ %s${_norm}\n" "$@"
}
function _warning() {
    printf "${_tan}⚠ %s${_norm}\n" "$@"
}
function _error() {
    printf "${_red}✗ %s${_norm}\n" "$@"
}

################################################################################
# MAIN FUNCTIONS
################################################################################
function _iotest() {
    python3 <(wget -qO- https://github.com/amefs/fio-bench/raw/master/fio-bench.py -o /dev/null) ${EXTRACMD}
}

function _getDistName()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux" /etc/issue || grep -Eq "Red Hat Enterprise Linux" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Amazon Linux" /etc/issue || grep -Eq "Amazon Linux" /etc/*-release; then
        DISTRO='Amazon'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
        DISTRO='Mint'
        PM='apt'
    elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
        DISTRO='Kali'
        PM='apt'
    else
        DISTRO='unknow'
    fi
}

function _CentOS_Dependent()
{
    _info "yum installing dependent packages..."
    for packages in epel-release wget fio python3;
    do yum -y install $packages > /dev/null 2>&1; done
    _success "yum packages installation finished"
    if ! $(which pip3 > /dev/null 2>&1); then
        _info "安装 python3-pip..."
        yum -y install python3-pip > /dev/null 2>&1
    else
        _success "python3-pip 已安装"
    fi
    _info "pip installing dependent packages..."
    python3 -m pip install prettytable > /dev/null 2>&1
    _success "pip packages installation finished"
}

function _Deb_Dependent()
{
    _info "apt-get installing dependent packages..."
    apt-get update -yqq > /dev/null 2>&1
    apt-get autoremove -yqq > /dev/null 2>&1
    apt-get -fy install > /dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    for packages in wget fio;
    do apt-get install -yqq $packages > /dev/null 2>&1; done
    if [[ "$(dpkg -s python3 2> /dev/null | grep -cow '^Status: install ok installed$')" -eq '1' ]];then
        _success "python3 installed"
    else
        _info "installing python3"
        apt-get install -yqq python3 > /dev/null 2>&1
        _success "python3 installed"
    fi
    if ! $(which pip3 > /dev/null 2>&1); then
        _info "installing python3-pip"
        apt-get install -yqq python3-pip > /dev/null 2>&1
	_success "python3-pip installed"
    else
        _success "python3-pip installed"
    fi
    _info "pip3 installing dependent packages..."
    python3 -m pip install prettytable > /dev/null 2>&1
    _success "pip3 packages installation finished"
}

function _checkdep() {
    _getDistName
	_info "Checking dependent packages"
    if ( [ ! -f /usr/bin/fio ] || ! $(which pip3 > /dev/null 2>&1) || ! $(python3 -m pip freeze --disable-pip-version-check | grep -q 'prettytable' > /dev/null 2>&1)); then
        _info "Installing dependent packages..."
        if [ "$PM" = "yum" ]; then
            _CentOS_Dependent
        elif [ "$PM" = "apt" ]; then
            _Deb_Dependent
        else
            _error "Unknown package manager!"
        fi
    else
        _success "Dependency check passed"
    fi
}

#################################################################################
# MAIN PROCESS
#################################################################################
_checkdep
_iotest