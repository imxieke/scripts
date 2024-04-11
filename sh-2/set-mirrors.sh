#!/usr/bin/env bash
# Ubuntu Debian Kali Deepin Uos Alpine Archlinux Centos Blackarch Brew

_check_os()
{
  if [[ -f /etc/os-release ]]; then
    if [[ -n "$(grep debian /etc/os-release )" ]]; then
      _OS=debian
    elif [[ -n "$(grep ubuntu /etc/os-release)" ]]; then
      _OS=ubuntu
    elif [[ -n "$(grep deepin /etc/os-release)" ]]; then
      _OS=deepin
    elif [[ -n "$(grep kali /etc/os-release)" ]]; then
      _OS=kali
    elif [[ -n "$(grep centos /etc/os-release)" ]]; then
      _OS=centos
    elif [[ -n "$(grep blackarch /etc/os-release)" ]]; then
      _OS=blackarch
    elif [[ -n "$(grep archlinux /etc/os-release)" ]]; then
      _OS=archlinux
    elif [[ -n "$(grep alpine /etc/os-release)" ]]; then
      _OS=alpine
    elif [[ "$(uname -s)" == 'Darwin' ]]; then
      _OS=macOS
    fi
  fi
}

_check_os

_check_version()
{
  case ${_OS} in
    ubuntu )
        if [[ -n "$(grep 'VERSION_CODENAME' /etc/os-release | awk -F '=' '{print $2}')" ]]; then
          _VERSION=$(grep 'VERSION_CODENAME' /etc/os-release | awk -F '=' '{print $2}')
        fi
      ;;
    centos )
        if [[ -n "$(grep 'VERSION_ID' /etc/os-release | awk -F '"' '{print $2}')" ]]; then
          _VERSION=$(grep 'VERSION_ID' /etc/os-release | awk -F '"' '{print $2}')
        fi
      ;;
  esac
}