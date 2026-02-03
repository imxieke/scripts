#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2026-02-03 15:10:05
 # @LastEditTime: 2026-02-03 15:54:31
 # @LastEditors: Cloudflying
 # @Description: Linux && macOS Tools (Bench)
###

ROOT_PATH="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

_red() {
    printf '\033[1;31;31m%b\033[0m' "$1"
}

_green() {
    printf '\033[1;31;32m%b\033[0m' "$1"
}

_yellow() {
    printf '\033[1;31;33m%b\033[0m' "$1"
}

_info() {
    _green "[Info] "
    printf -- "%s" "$1"
    printf "\n"
}

_warn() {
    _yellow "[Warning] "
    printf -- "%s" "$1"
    printf "\n"
}

_error() {
    _red "[Error] "
    printf -- "%s" "$1"
    printf "\n"
    exit 1
}

get_os_info()
{
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [[ -f /etc/lsb-release ]]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    else
        _error "Unknown OS"
    fi
}

get_cpu_info()
{
  if [[ "$(uname -s)" == 'Linux' ]]; then
    if [[ -f "/proc/cpuinfo" ]]; then
      CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -n 1 | awk '{print substr($0, index($0,$4))}')
      CPU_CORES=$(grep -c ^processor /proc/cpuinfo)
      CPU_MHZ=$(grep "cpu MHz" /proc/cpuinfo | head -n 1 | awk '{print substr($0, index($0,$4))}')
      CPU_CACHE=$(grep "cache size" /proc/cpuinfo | head -n 1 | awk '{print substr($0, index($0,$4))}')
    fi
  fi
}

is_wsl()
{
    case "$(uname -r)" in
      *microsoft*) echo 0 ;;
      *) echo 1 ;;
    esac
}

print_system_info()
{
  if [[ "$(is_wsl)" ]]; then
    DISTRO_SUFFIX="On Windows $(uname -m) (WSL)"
  fi

  echo "$(_green "Distro :")" "${OS} ${DISTRO_SUFFIX}"
  echo "$(_green "Kernel :")" "$(uname -r)"
  echo "$(_green "CPU    :")" "${CPU_MODEL}" "(${CPU_CORES} Cores @ ${CPU_MHZ}MHz)"
}

get_os_info
get_cpu_info

print_system_info