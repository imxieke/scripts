#!/usr/bin/env bash
###
# @Author: Cloudflying
# @Date: 2023-09-09 17:16:35
# @LastEditTime: 2024-06-17 21:55:24
# @LastEditors: Cloudflying
# @Description: Neo Utils: Server Utils (OS: macOS Debian-Like Arch-Like Alpine) (Arch: x86 x86_64 arm aarch64)
###

NEO_VERSION="20240616"
OOKLA_SPEEDTEST_VER="1.2.0"

# example
# https://github.com/masonr/yet-another-bench-script/blob/master/yabs.sh
# https://github.com/teddysun/across/blob/master/bench.sh

start_time=$(date +%s)

# determine architecture of host
ARCH=$(uname -m)
KERNEL_BIT=$(getconf LONG_BIT)
if [[ $ARCH = *x86_64* ]]; then
  # host is running a 64-bit kernel
  ARCH="x86_64"
elif [[ $ARCH = *i?86* ]]; then
  # host is running a 32-bit kernel
  ARCH="x86"
# host is running an ARM 64-bit kernel
elif [[ $ARCH = *aarch* || $ARCH = *armv8* || $ARCH = *arm64* ]]; then
  ARCH="aarch64"
elif [[ $ARCH = *armv7* ]]; then
  ARCH="armhf"
elif [[ $ARCH = *armv6* ]]; then
  ARCH="armel"
elif [[ $ARCH = *arm* ]]; then
  # host is running an ARM 32-bit kernel
  ARCH="arm"
  echo -e "\nARM compatibility is considered *experimental*"
else
  # host is running a non-supported kernel
  echo -e "Architecture not supported."
  exit 1
fi

_red() {
  printf '\033[0;31;31m%b\033[0m' "$1"
}

_green() {
  printf '\033[0;31;32m%b\033[0m' "$1"
}

_yellow() {
  printf '\033[0;31;33m%b\033[0m' "$1"
}

_blue() {
  printf '\033[0;31;36m%b\033[0m' "$1"
}

_about() {
  echo ""
  echo " ========================================================= "
  echo " #                  Neo Utils  v${NEO_VERSION}                 # "
  echo " #       Basic system info, I/O test and speedtest       # "
  echo " #               Created by Cloudflying                  # "
  echo " ========================================================= "
  echo ""
}

_usage() {
  echo "      Usage: " $(_blue neobench.sh)" [io|info|speed|all|help]"
  echo ""
}

_next() {
  printf "%-70s\n" "-" | sed 's/\s/-/g'
}

cancel() {
  echo ""
  _next
  echo " Abort ..."
  _red "\nThe script has been terminated. Cleaning up files...\n"
  echo " Done"
  exit
}

trap cancel SIGINT INT QUIT TERM

print_end_time() {
  end_time=$(date +%s)
  time=$((end_time - start_time))
  if [ ${time} -gt 60 ]; then
    min=$((time / 60))
    sec=$((time % 60))
    echo " Finished in    : $(_red ${min} min ${sec} sec)"
  else
    echo " Finished in    : $(_red ${min} min ${sec} sec)"
  fi
}

# Depends Check
_depends() {
  depends=(
    jq
    wget
    curl
    dmidecode
  )
  # depends_darwin=()
  if ! command -v jq >/dev/null 2>&1; then
    ${_pkgupdate}
  fi

  for depend in "${depends[@]}"; do
    if ! command -v ${depend} >/dev/null 2>&1; then
      echo "==> " $(_red ${depend}) " not found, installing..."
      ${_pkgadd} ${depend}
    fi
  done
}

# Env Check
_check() {
  echo "check"
}

size_format() {
  local raw=$1
  local total_size=0
  local num=1
  local unit="KB"
  if ! [[ ${raw} =~ ^[0-9]+$ ]]; then
    echo ""
    return
  fi
  if [ "${raw}" -ge 1073741824 ]; then
    num=1073741824
    unit="TB"
  elif [ "${raw}" -ge 1048576 ]; then
    num=1048576
    unit="GB"
  elif [ "${raw}" -ge 1024 ]; then
    num=1024
    unit="MB"
  elif [ "${raw}" -eq 0 ]; then
    echo "${total_size}"
    return
  fi
  total_size=$(awk 'BEGIN{printf "%.1f", '"$raw"' / '$num'}')
  echo "${total_size} ${unit}"
}

# since size_format converts kilobyte to MB, GB and TB
# to_kibyte converts zfs size from bytes to kilobyte
to_kibyte() {
  local raw=$1
  awk 'BEGIN{printf "%.0f", '"$raw"' / 1024}'
}

calc_sum() {
  local arr=("$@")
  local s
  s=0
  for i in "${arr[@]}"; do
    s=$((s + i))
  done
  echo ${s}
}

osinfo() {
  if [[ -f "/etc/os-release" ]]; then
    . /etc/os-release
    if [[ -n "$(echo ${PRETTY_NAME} | grep -i "Arch")" ]]; then
      OSNAME=${ID}                 # arch
      OSNAME_PRETTY=${PRETTY_NAME} # Arch Linux
      OSCODE=${BUILD_ID}           # rolling
      OSVER=${VERSION_ID}          # 20240421.0.230473
      _pkgupdate="pacman -Syy --noconfirm"
      _pkgadd="pacman -S --noconfirm"
    elif [[ -n "$(echo ${PRETTY_NAME} | grep -i "Debian GNU/Linux")" ]]; then
      OSNAME=${ID}                 # debian
      OSNAME_PRETTY=${PRETTY_NAME} # Debian GNU/Linux 12 (bookworm)
      OSCODE=${VERSION_CODENAME}   # bookworm
      OSVER=${VERSION_ID}          # 12
      _pkgupdate="apt update -y"
      _pkgadd="apt install -y"
    elif [[ -n "$(echo ${PRETTY_NAME} | grep -i "Ubuntu")" ]]; then
      OSNAME=${ID}                 # ubuntu
      OSNAME_PRETTY=${PRETTY_NAME} # Ubuntu 24.04 LTS
      OSCODE=${VERSION_CODENAME}   # noble
      OSVER=${VERSION_ID}          # 24.04
      _pkgupdate="apt update -y"
      _pkgadd="apt install -y"
    elif [[ -n "$(echo ${PRETTY_NAME} | grep -i "Alpine Linux")" ]]; then
      OSNAME=${ID}                 # alpine
      OSNAME_PRETTY=${PRETTY_NAME} # Alpine Linux v3.19
      OSCODE=${VERSION_CODENAME}   # null
      OSVER=${VERSION_ID}          # 3.19.1
      _pkgadd="apk add"
      _pkgupdate="apk update"
    fi
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    OSNAME=$(uname -s)           # Darwin
    OSNAME_PRETTY=${PRETTY_NAME} # Alpine Linux v3.19
    OSCODE=${VERSION_CODENAME}   # null
    OSVER=$(uname -r)            # 3.19.1
    _pkgadd="brew install"
  fi
}

sysinfo() {
  if [[ -n "${SHELL}" ]]; then
    OS_SHELL=$(echo $SHELL | awk -F '/' '{print $NF}')
  elif [[ -n {$0} ]]; then
    OS_SHELL=$(echo $0 | awk -F '/' '{print $NF}')
  fi
  if [[ -n "$(command -v nproc)" ]]; then
    CPU_CORES=$(nproc)
  fi

  if [[ -f "/proc/loadavg" ]]; then
    OS_LOADAVG=$(awk -F " " '{print $1","$2","$3}' /proc/loadavg)
  elif [[ -n "$(command -v uptime)" ]]; then
    OS_LOADAVG=$(uptime | awk -F ": " '{print $2}')
  fi

  if [[ -f "/proc/uptime" ]]; then
    UPTIME=$(awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d Days, %d Hours %d Minutes\n",a,b,c)}' /proc/uptime)
  elif [[ -n "$(command -v uptime)" ]]; then
    UPTIME_STR=$(uptime | awk -F " " '{print $3}')
    UPTIME_DAY="$(echo "${UPTIME_STR}" | sed "s#,##g" | awk -F ":" '{print $1}') Days"
    UPTIME_HOUR="$(echo "${UPTIME_STR}" | sed "s#,##g" | awk -F ":" '{print $2}') Hours"
    UPTIME_MIN="$(echo "${UPTIME_STR}" | sed "s#,##g" | awk -F ":" '{print $3}') Minutes"
    UPTIME="${UPTIME_DAY} ${UPTIME_HOUR} ${UPTIME_MIN}"
  fi

  OS_KERNEL=$(uname -r)
  # TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3}')
  # TIMEZONE=$(date | awk -F " " '{print $6}')

  if [[ "$(uname -s)" == "Darwin" ]]; then
    CPU_MODEL=$(sysctl -n machdep.cpu.brand_string)
  elif [[ "$(uname -s)" == "Linux" ]]; then
    if [[ -f "/proc/cpuinfo" ]]; then
      CPU_CORES=$(grep -c 'processor' /proc/cpuinfo)
      CPU_MODEL=$(awk -F ': ' '/model name/{print $2}' /proc/cpuinfo | uniq)
      CPU_FREQ=$(awk -F'[ :]' '/cpu MHz/ {print $4;exit}' /proc/cpuinfo)
      CPU_CACHE=$(awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
      CPU_VIRT=$(grep -Ei 'vmx|svm' /proc/cpuinfo)
    fi
    RAM_TOTAL=$(awk '/MemTotal/{print $2}' /proc/meminfo)
    RAM_TOTAL=$(size_format "${RAM_TOTAL}")
    RAM_FREE=$(awk '/MemFree/{print $2}' /proc/meminfo)
    RAM_FREE=$(size_format "${RAM_FREE}")
    # RAM_USED=$(calc_sum "${RAM_TOTAL}" "${RAM_FREE}")
    SWAP_TOTAL=$(awk '/SwapTotal/{print $2}' /proc/meminfo)
    SWAP_TOTAL=$(size_format "${SWAP_TOTAL}")
    SWAP_FREE=$(awk '/SwapFree/{print $2}' /proc/meminfo)
    SWAP_FREE=$(size_format "${SWAP_FREE}")
    if [[ -n "$(command -v sysctl)" ]]; then
      TCPCC=$(sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}')
    fi
    # Max Show 5 Disk
    DISK_COUNT=$(df -h | grep -c -vE '^Filesystem|tmpfs|cdrom|none|udev|cgroup|/etc|/dev' | head -n 5)
    DISK_INFO=""
    if [[ -n "${DISK_COUNT}" ]]; then
      for ((i = 1; i <= "${DISK_COUNT}"; i++)); do
        DISK_TOTAL=$(df -h | grep -vE '^Filesystem|tmpfs|cdrom|none|udev|cgroup|/etc|/dev' | tail -n +${i} | head -n 1 | awk '{print $2}')
        DISK_USED=$(df -h | grep -vE '^Filesystem|tmpfs|cdrom|none|udev|cgroup|/etc|/dev' | tail -n +${i} | head -n 1 | awk '{print $3}')
        DISK_FREE=$(df -h | grep -vE '^Filesystem|tmpfs|cdrom|none|udev|cgroup|/etc|/dev' | tail -n +${i} | head -n 1 | awk '{print $4}')
        DISK_PER=$(df -h | grep -vE '^Filesystem|tmpfs|cdrom|none|udev|cgroup|/etc|/dev' | tail -n +${i} | head -n 1 | awk '{print $5}')
        DISK_POINT=$(df -h | grep -vE '^Filesystem|tmpfs|cdrom|none|udev|cgroup|/etc|/dev' | tail -n +${i} | head -n 1 | awk '{print $6}')
        # DISK_INFO+="Disk ${i}: Total: ${DISK_TOTAL} Used: ${DISK_USED} Free: ${DISK_FREE} Per: ${DISK_PER} Mount On: ${DISK_POINT} | "
        DISK_INFO+="Disk ${i}: ${DISK_TOTAL}(${DISK_FREE} Free, ${DISK_PER}, On: ${DISK_POINT}) "
      done
    fi
  fi
}

_network() {
  # test if the host has IPv4/IPv6 connectivity
  [[ -n ${local_curl} ]] && ip_check_cmd="curl -s -m 4" || ip_check_cmd="wget -qO- -T 4"
  ipv4_check=$( (ping -4 -c 1 -W 4 ipv4.google.com >/dev/null 2>&1 && echo true) || ${ip_check_cmd} -4 icanhazip.com 2>/dev/null)
  ipv6_check=$( (ping -6 -c 1 -W 4 ipv6.google.com >/dev/null 2>&1 && echo true) || ${ip_check_cmd} -6 icanhazip.com 2>/dev/null)
  if [[ -z "$ipv4_check" && -z "$ipv6_check" ]]; then
    _yellow "Warning: Both IPv4 and IPv6 connectivity were not detected.\n"
  fi
}

# TODO replace with https://api.xie.ke/ip
ipinfo() {
  v4info=$(curl --connect-timeout 10 -fsL4 https://ipapi.co/json/)
  v6info=$(curl --connect-timeout 10 -fsL6 https://ipapi.co/json/)
}

ipv4_info() {
  local org city country region
  org="$(wget -q -T10 -O- ipinfo.io/org)"
  city="$(wget -q -T10 -O- ipinfo.io/city)"
  country="$(wget -q -T10 -O- ipinfo.io/country)"
  region="$(wget -q -T10 -O- ipinfo.io/region)"
  if [[ -n "${org}" ]]; then
    echo " Organization       : $(_blue "${org}")"
  fi
  if [[ -n "${city}" && -n "${country}" ]]; then
    echo " Location           : $(_blue "${city} / ${country}")"
  fi
  if [[ -n "${region}" ]]; then
    echo " Region             : $(_yellow "${region}")"
  fi
  if [[ -z "${org}" ]]; then
    echo " Region             : $(_red "No ISP detected")"
  fi
}

# https://www.speedtest.net/apps/cli
install_ookla_speedtest() {
  if [ ! -e "./speedtest-cli/speedtest" ]; then
    if [[ "${ARCH}" == 'x86' ]]; then
      url="https://install.speedtest.net/app/cli/ookla-speedtest-${OOKLA_SPEEDTEST_VER}linux-i386.tgz"
    fi
    url="https://install.speedtest.net/app/cli/ookla-speedtest-${OOKLA_SPEEDTEST_VER}-linux-${ARCH}.tgz"
    if ! wget --no-check-certificate -q -T10 -O speedtest.tgz ${url}; then
      _red "Error: Failed to download speedtest-cli.\n" && exit 1
    fi
    mkdir -p speedtest-cli && tar zxf speedtest.tgz -C ./speedtest-cli && chmod +x ./speedtest-cli/speedtest
    rm -f speedtest.tgz
  fi
}

speed_test() {
  install_ookla_speedtest
  local nodeName="$2"
  if [ -z "$1" ]; then
    ./speedtest-cli/speedtest --progress=no --accept-license --accept-gdpr >./speedtest-cli/speedtest.log 2>&1
  else
    ./speedtest-cli/speedtest --progress=no --server-id="$1" --accept-license --accept-gdpr >./speedtest-cli/speedtest.log 2>&1
  fi
  if [ $? -eq 0 ]; then
    local dl_speed up_speed latency
    dl_speed=$(awk '/Download/{print $3" "$4}' ./speedtest-cli/speedtest.log)
    up_speed=$(awk '/Upload/{print $3" "$4}' ./speedtest-cli/speedtest.log)
    latency=$(awk '/Latency/{print $3" "$4}' ./speedtest-cli/speedtest.log)
    if [[ -n "${dl_speed}" && -n "${up_speed}" && -n "${latency}" ]]; then
      printf "\033[0;33m%-18s\033[0;32m%-18s\033[0;31m%-20s\033[0;36m%-12s\033[0m\n" " ${nodeName}" "${up_speed}" "${dl_speed}" "${latency}"
    fi
  fi
}

_speedtest() {
  printf "%-18s%-18s%-20s%-12s\n" " Node Name" "Upload Speed" "Download Speed" "Latency"
  # speed_test '' 'Speedtest.net'
  # speed_test '21541' 'Los Angeles, US'
  # speed_test '43860' 'Dallas, US'
  # speed_test '40879' 'Montreal, CA'
  # speed_test '24215' 'Paris, FR'
  # speed_test '28922' 'Amsterdam, NL'
  speed_test '24447' 'Shanghai, CN'
  # speed_test '5530' 'Chongqing, CN'
  speed_test '60572' 'Guangzhou, CN'
  speed_test '32155' 'Hongkong, CN'
  # speed_test '23647' 'Mumbai, IN'
  speed_test '13623' 'Singapore, SG'
  speed_test '21569' 'Tokyo, JP'
}

io_test() {
  (LANG=C dd if=/dev/zero of=benchtest_$$ bs=512k count="$1" conv=fdatasync && rm -f benchtest_$$) 2>&1 | awk -F '[,，]' '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

print_io_test() {
  freespace=$(df -m . | awk 'NR==2 {print $4}')
  if [ -z "${freespace}" ]; then
    freespace=$(df -m . | awk 'NR==3 {print $3}')
  fi
  if [ "${freespace}" -gt 1024 ]; then
    echo $(_yellow "==> Start I/O Speed Test")
    writemb=2048
    io1=$(io_test ${writemb})
    echo " I/O Speed(1st run) : $(_yellow "$io1")"
    io2=$(io_test ${writemb})
    echo " I/O Speed(2nd run) : $(_yellow "$io2")"
    io3=$(io_test ${writemb})
    echo " I/O Speed(3rd run) : $(_yellow "$io3")"
    ioraw1=$(echo "$io1" | awk 'NR==1 {print $1}')
    [[ "$(echo "$io1" | awk 'NR==1 {print $2}')" == "GB/s" ]] && ioraw1=$(awk 'BEGIN{print '"$ioraw1"' * 1024}')
    ioraw2=$(echo "$io2" | awk 'NR==1 {print $1}')
    [[ "$(echo "$io2" | awk 'NR==1 {print $2}')" == "GB/s" ]] && ioraw2=$(awk 'BEGIN{print '"$ioraw2"' * 1024}')
    ioraw3=$(echo "$io3" | awk 'NR==1 {print $1}')
    [[ "$(echo "$io3" | awk 'NR==1 {print $2}')" == "GB/s" ]] && ioraw3=$(awk 'BEGIN{print '"$ioraw3"' * 1024}')
    ioall=$(awk 'BEGIN{print '"$ioraw1"' + '"$ioraw2"' + '"$ioraw3"'}')
    ioavg=$(awk 'BEGIN{printf "%.1f", '"$ioall"' / 3}')
    echo " I/O Speed(average) : $(_yellow "$ioavg MB/s")"
  else
    echo " $(_red "Not enough space for I/O Speed test!")"
  fi
}

_virt() {
  # docker don't have this file
  if [[ -f "/dev/mem" ]]; then
    sys_manu="$(dmidecode -s system-manufacturer 2>/dev/null)"
    sys_product="$(dmidecode -s system-product-name 2>/dev/null)"
    sys_ver="$(dmidecode -s system-version 2>/dev/null)"
  else
    sys_manu=""
    sys_product=""
    sys_ver=""
  fi

  if [[ -f "/.dockerenv" ]]; then
    OS_VIRT="Docker"
  elif [[ -n "$(uname -r | grep linuxkit)" ]]; then
    OS_VIRT="Docker"
  elif [[ -n "$(cat /etc/resolv.conf | grep Docker)" ]]; then
    OS_VIRT="Docker"
  elif [[ -n "$(cat /etc/hosts | grep Docker)" ]]; then
    OS_VIRT="Docker"
  elif [[ -n "$(grep -qa lxc /proc/1/cgroup)" ]]; then
    OS_VIRT="Lxc"
  elif [[ -n "$(grep -qa container=lxc /proc/1/environ)" ]]; then
    OS_VIRT="Lxc"
  # OpenVZ/Virtuozzo
  elif [[ -f "/proc/vz" ]]; then
    OS_VIRT="OpenVZ"
  elif [[ -f "/proc/user_beancounters" ]]; then
    OS_VIRT="OpenVZ"
  elif [[ -n "$(lscpu | grep 'Hypervisor vendor' | grep -i kvm)" ]]; then
    OS_VIRT="KVM"
  elif [ -f "/sys/class/dmi/id/product_name" ] && [ "$(cat /sys/class/dmi/id/product_name | grep -i kvm)" ]; then
    OS_VIRT="KVM"
  elif [[ "${CPU_MODEL}" == *KVM* ]]; then
    OS_VIRT="KVM"
  elif [[ "${CPU_MODEL}" == *QEMU* ]]; then
    OS_VIRT="KVM"
  elif [ -f "/sys/class/dmi/id/product_name" ] && [ "$(cat /sys/class/dmi/id/product_name | grep -i qemu)" ]; then
    OS_VIRT="QEMU"
  elif [ -f "/sys/class/dmi/id/product_name" ] && [ "$(cat /sys/class/dmi/id/product_name | grep -i parallels)" ]; then
    OS_VIRT="Parallels"
  elif [ -f "/sys/class/dmi/id/product_name" ] && [ "$(cat /sys/class/dmi/id/product_name | grep -i virtualbox)" ]; then
    OS_VIRT="VirtualBox"
  elif [ -f "/sys/class/dmi/id/product_name" ] && [ "$(cat /sys/class/dmi/id/product_name | grep -i vmware)" ]; then
    OS_VIRT="Vmware"
  elif [[ -n "$(lscpu | grep 'Hypervisor vendor' | grep -i vmware)" ]]; then
    OS_VIRT="Vmware"
  elif [[ -n "$(cat /proc/cpuinfo | grep -i vmware)" ]]; then
    OS_VIRT="Vmware"
  elif [[ -e /proc/xen ]]; then
    if grep -q "control_d" "/proc/xen/capabilities" 2>/dev/null; then
      OS_VIRT="Xen-Dom0"
    else
      OS_VIRT="Xen-DomU"
    fi
  elif [ -f "/sys/hypervisor/type" ] && grep -q "xen" "/sys/hypervisor/type"; then
    OS_VIRT="Xen"
  elif [ -f "/etc/wsl.conf" ]; then
    OS_VIRT="Hyper-V (WSL)"
  elif [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ]; then
    OS_VIRT="Hyper-V (WSL)"
  elif [[ "${sys_manu}" == *"Microsoft Corporation"* ]]; then
    if [[ "${sys_product}" == *"Virtual Machine"* ]]; then
      if [[ "${sys_ver}" == *"7.0"* || "${sys_ver}" == *"Hyper-V" ]]; then
        OS_VIRT="Hyper-V"
      else
        OS_VIRT="Microsoft Virtual Machine"
      fi
    fi
  else
    OS_VIRT="Dedicated"
  fi

  if [ -z "${OS_VIRT}" ] || [ "${OS_VIRT}" == 'Dedicated' ]; then
    if [[ -n "$(command -v systemd-detect-virt)" ]]; then
      OS_VIRT=$(systemd-detect-virt)
      if [[ "${OS_VIRT}" == "none" ]]; then
        OS_VIRT="Dedicated"
      fi
    fi
  fi
}

print_sysinfo() {
  [ -n "${OSNAME_PRETTY}" ] && echo " OS             : $(_blue "${OSNAME_PRETTY} ${ARCH}")"
  [ -n "${OS_KERNEL}" ] && echo " Kernel         : $(_blue "${OS_KERNEL}")"
  [ -n "${ARCH}" ] && echo " Arch           : $(_blue "${ARCH} ${KERNEL_BIT} Bit")"
  [ -n "${OS_VIRT}" ] && echo " Virtual        : $(_blue "${OS_VIRT}")"
  [ -n "${RAM_TOTAL}" ] && echo " Memory         : $(_blue "${RAM_TOTAL} (${RAM_FREE} Free)")"
  [ -n "${DISK_INFO}" ] && echo " Disk           : $(_blue "${DISK_INFO}")"
  [ -n "${SWAP_TOTAL}" ] && echo " Swap           : $(_blue "${SWAP_TOTAL} (${SWAP_FREE} Free)")"
  [ -n "${OS_SHELL}" ] && echo " Shell          : $(_blue "${OS_SHELL}")"
  [ -n "${UPTIME}" ] && echo " Uptime         : $(_blue "${UPTIME}")"
  [ -n "${OS_LOADAVG}" ] && echo " Load AVG       : $(_blue "${OS_LOADAVG}")"
  [ -n "${TCPCC}" ] && echo " TCP CC         : $(_blue "${TCPCC}")"
  echo " Server Time    : $(_blue "$(date "+%Y-%m-%d %k:%M:%S")")"

  if [ -n "${CPU_MODEL}" ]; then
    echo " CPU Model      : $(_blue "${CPU_MODEL} (${CPU_CORES} Core)")"
  else
    echo " CPU Model      : $(_blue "CPU model not detected")"
  fi
}

_init() {
  osinfo
  sysinfo
  # _depends
  _virt
}

_init

ACT=$1
OPTS=$2

case "${ACT}" in
  io | --io)
    print_io_test
    ;;
  info | --info)
    print_sysinfo
    ;;
  ipinfo | --ipinfo)
    ipv4_info
    ;;
  speedtest | --speedtest)
    _speedtest
    ;;
  *)
    _about
    _usage
    ;;
esac

# print_end_time
