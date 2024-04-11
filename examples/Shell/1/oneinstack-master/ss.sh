#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://blog.linuxeye.com
#
# Notes: OneinStack for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+
#        Install SS Server
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/lj2007331/oneinstack

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#######################################################################
#       OneinStack for CentOS/RadHat 6+ Debian 6+ and Ubuntu 12+      #
#                         Install SS Server                           #
#       For more information please visit https://oneinstack.com      #
#######################################################################
"

# get pwd
sed -i "s@^oneinstack_dir.*@oneinstack_dir=$(pwd)@" ./options.conf

pushd src > /dev/null
. ../options.conf
. ../versions.txt
. ../include/color.sh
. ../include/check_os.sh
. ../include/download.sh
. ../include/python.sh

# Check if user is root
[ $(id -u) != '0' ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

PUBLIC_IPADDR=$(../include/get_public_ipaddr.py)

[ "${CentOS_RHEL_version}" == '5' ] && { echo "${CWARNING}SS only support CentOS6,7 or Debian or Ubuntu! ${CEND}"; exit 1; }

Check_SS() {
  [ -f /usr/local/bin/ss-server ] && SS_version=1
  [ -f ${python_install_dir}/bin/ssserver ] && SS_version=2
}

AddUser_SS() {
  while :; do echo
    read -p "Please input password for SS: " SS_password
    [ -n "$(echo ${SS_password} | grep '[+|&]')" ] && { echo "${CWARNING}input error,not contain a plus sign (+) and & ${CEND}"; continue; }
    (( ${#SS_password} >= 5 )) && break || echo "${CWARNING}SS password least 5 characters! ${CEND}"
  done
}

Iptables_set() {
  if [ -e '/etc/sysconfig/iptables' ]; then
    SS_Already_port=$(grep -oE '9[0-9][0-9][0-9]' /etc/sysconfig/iptables | head -n 1)
  elif [ -e '/etc/iptables.up.rules' ]; then
    SS_Already_port=$(grep -oE '9[0-9][0-9][0-9]' /etc/iptables.up.rules | head -n 1)
  fi

  if [ -n "${SS_Already_port}" ]; then
    let SS_Default_port="${SS_Already_port}+1"
  else
    SS_Default_port=9001
  fi

  while :; do echo
    read -p "Please input SS port(Default: ${SS_Default_port}): " SS_port
    [ -z "${SS_port}" ] && SS_port=${SS_Default_port}
    if [ ${SS_port} -ge 1 >/dev/null 2>&1 -a ${SS_port} -le 65535 >/dev/null 2>&1 ]; then
      [ -z "$(netstat -tpln | grep :${SS_port}$)" ] && break || echo "${CWARNING}This port is already used! ${CEND}"
    else
      echo "${CWARNING}input error! Input range: 1~65535${CEND}"
    fi
  done

  if [ "${OS}" == 'CentOS' ]; then
    if [ -z "$(grep -E ${SS_port} /etc/sysconfig/iptables)" ]; then
      iptables -I INPUT 4 -p udp -m state --state NEW -m udp --dport ${SS_port} -j ACCEPT
      iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport ${SS_port} -j ACCEPT
      service iptables save
    fi
  elif [[ ${OS} =~ ^Ubuntu$|^Debian$ ]]; then
    if [ -z "$(grep -E ${SS_port} /etc/iptables.up.rules)" ]; then
      iptables -I INPUT 4 -p udp -m state --state NEW -m udp --dport ${SS_port} -j ACCEPT
      iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport ${SS_port} -j ACCEPT
      iptables-save > /etc/iptables.up.rules
    fi
  else
      echo "${CWARNING}This port is already in iptables! ${CEND}"
  fi

}

Def_parameter() {
  if [ "${OS}" == "CentOS" ]; then
    while :; do echo
      echo "Please select SS server version:"
      echo -e "\t${CMSG}1${CEND}. Install SS-libev"
      echo -e "\t${CMSG}2${CEND}. Install SS-python"
      read -p "Please input a number:(Default 1 press Enter) " SS_version
      [ -z "${SS_version}" ] && SS_version=1
      if [[ ! "${SS_version}" =~ ^[1-2]$ ]]; then
        echo "${CWARNING}input error! Please only input number 1,2${CEND}"
      else
        break
      fi
    done
    AddUser_SS
    Iptables_set
    pkgList="wget unzip openssl-devel gcc swig autoconf libtool libevent automake make curl curl-devel zlib-devel perl perl-devel cpio expat-devel gettext-devel git asciidoc xmlto pcre-devel"
    for Package in ${pkgList}; do
      yum -y install ${Package}
    done
  elif [[ "${OS}" =~ ^Ubuntu$|^Debian$ ]]; then
    SS_version=2
    AddUser_SS
    Iptables_set
    apt-get -y update
    pkgList="curl wget unzip gcc swig automake make perl cpio git"
    for Package in ${pkgList}; do
      apt-get -y install $Package
    done
  fi
}

Install_SS-python() {
  [ ! -e "${python_install_dir}/bin/python" ] && Install_Python
  ${python_install_dir}/bin/pip install M2Crypto
  ${python_install_dir}/bin/pip install greenlet
  ${python_install_dir}/bin/pip install gevent
  ${python_install_dir}/bin/pip install shadowsocks
  if [ -f ${python_install_dir}/bin/ssserver ]; then 
    /bin/cp ../init.d/SS-python-init /etc/init.d/shadowsocks
    chmod +x /etc/init.d/shadowsocks
    sed -i "s@SS_bin=.*@SS_bin=${python_install_dir}/bin/ssserver@" /etc/init.d/shadowsocks
    [ "${OS}" == "CentOS" ] && { chkconfig --add shadowsocks; chkconfig shadowsocks on; }
    [[ "${OS}" =~ ^Ubuntu$|^Debian$ ]] && update-rc.d shadowsocks defaults
  else
    echo
    echo "${CQUESTION}SS-python install failed! Please visit https://oneinstack.com${CEND}"
    exit 1
  fi
}

Install_SS-libev() {
  git clone https://github.com/shadowsocks/shadowsocks-libev.git
  pushd shadowsocks-libev
  ./configure
  make -j ${THREAD} && make install
  popd
  if [ -f /usr/local/bin/ss-server ]; then
    /bin/cp ../init.d/SS-libev-init /etc/init.d/shadowsocks
    chmod +x /etc/init.d/shadowsocks
    [ "${OS}" == "CentOS" ] && { chkconfig --add shadowsocks; chkconfig shadowsocks on; }
  else
    echo
    echo "${CQUESTION}SS-libev install failed! Please visit https://oneinstack.com${CEND}"
    exit 1
  fi

}

Uninstall_SS() {
  while :; do echo
    read -p "Do you want to uninstall SS? [y/n]: " SS_yn
    if [[ ! "${SS_yn}" =~ ^[y,n]$ ]]; then
      echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
    else
      break
    fi
  done

  if [ "${SS_yn}" == 'y' ]; then
    [ -n "$(ps -ef | grep -v grep | grep -iE "ssserver|ss-server")" ] && /etc/init.d/shadowsocks stop
    [ "${OS}" == "CentOS" ] && chkconfig --del shadowsocks
    [[ "${OS}" =~ ^Ubuntu$|^Debian$ ]] && update-rc.d -f shadowsocks remove
    rm -rf /etc/shadowsocks /var/run/shadowsocks.pid /etc/init.d/shadowsocks
    if [ "${SS_version}" == '1' ]; then
      rm -f /usr/local/bin/{ss-local,ss-tunnel,ss-server,ss-manager,ss-redir}
      rm -f /usr/local/lib/libshadowsocks.*
      rm -f /usr/local/include/shadowsocks.h
      rm -f /usr/local/lib/pkgconfig/shadowsocks-libev.pc
      rm -f /usr/local/share/man/man1/{ss-local.1,ss-tunnel.1,ss-server.1,ss-manager.1,ss-redir.1,shadowsocks.8}
      if [ $? -eq 0 ]; then
        echo "${CSUCCESS}SS-libev uninstall successful! ${CEND}"
      else
        echo "${CFAILURE}SS-libev uninstall failed! ${CEND}"
      fi
    elif [ "${SS_version}" == '2' ]; then
      pip uninstall -y shadowsocks
      if [ $? -eq 0 ]; then
        echo "${CSUCCESS}SS-python uninstall successful! ${CEND}"
      else
        echo "${CFAILURE}SS-python uninstall failed! ${CEND}"
      fi
    fi
  fi
}

Config_SS() {
  [ ! -d "/etc/shadowsocks" ] && mkdir /etc/shadowsocks
  [ "${SS_version}" == '1' ] && cat > /etc/shadowsocks/config.json << EOF
{
    "server":"0.0.0.0",
    "server_port":${SS_port},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${SS_password}",
    "timeout":300,
    "method":"aes-256-cfb",
}
EOF

  [ "${SS_version}" == '2' ] && cat > /etc/shadowsocks/config.json << EOF
{
    "server":"0.0.0.0",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "port_password":{
    "${SS_port}":"${SS_password}"
    },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":false
}
EOF
}

AddUser_Config_SS() {
  [ ! -e /etc/shadowsocks/config.json ] && { echo "${CFAILURE}SS is not installed! ${CEND}"; exit 1; }
  [ -z "$(grep \"${SS_port}\" /etc/shadowsocks/config.json)" ] && sed -i "s@\"port_password\":{@\"port_password\":{\n\t\"${SS_port}\":\"${SS_password}\",@" /etc/shadowsocks/config.json || { echo "${CWARNING}This port is already in /etc/shadowsocks/config.json${CEND}"; exit 1; }
}

Print_User_SS() {
  printf "
Your Server IP: ${CMSG}${PUBLIC_IPADDR}${CEND}
Your Server Port: ${CMSG}${SS_port}${CEND}
Your Password: ${CMSG}${SS_password}${CEND}
Your Local IP: ${CMSG}127.0.0.1${CEND}
Your Local Port: ${CMSG}1080${CEND}
Your Encryption Method: ${CMSG}aes-256-cfb${CEND}
"
}

case "$1" in
install)
  Def_parameter
  [ "${SS_version}" == '1' ] && Install_SS-libev
  [ "${SS_version}" == '2' ] && Install_SS-python
  Config_SS
  service shadowsocks start
  Print_User_SS
  ;;
adduser)
  Check_SS
  if [ "${SS_version}" == '2' ]; then
    AddUser_SS
    Iptables_set
    AddUser_Config_SS
    service shadowsocks restart
    Print_User_SS
  else
    printf "
    Sorry, we have no plan to support multi port configuration. Actually you can use multiple instances instead. For example:
    ss-server -c /etc/shadowsocks/config1.json -f /var/run/shadowsocks-server/pid1
    ss-server -c /etc/shadowsocks/config2.json -f /var/run/shadowsocks-server/pid2
    "
  fi
  ;;
uninstall)
  Check_SS
  Uninstall_SS
  ;;
*)
  echo
  echo "Usage: ${CMSG}$0${CEND} { ${CMSG}install${CEND} | ${CMSG}adduser${CEND} | ${CMSG}uninstall${CEND} }"
  echo
  exit 1
esac
