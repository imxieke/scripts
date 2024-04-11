#!/usr/bin/env bash
#
#                  Caddy Installer Script
#
#   Homepage: https://caddyserver.com
#   Issues:   https://github.com/caddyserver/getcaddy.com/issues
#   Requires: bash, curl or wget, tar or unzip
#
# Hello! This is an experimental script that installs Caddy
# into your PATH (which may require password authorization).
# Use it like this:
#
#	$ curl https://getcaddy.com | bash
#	 or
#	$ wget -qO- https://getcaddy.com | bash
#
# In automated environments, you may want to run as root.
# If using curl, we recommend using the -fsSL flags.
#
# If you want to get Caddy with extra features, use -s with a
# comma-separated list of directives, like this:
#
#	$ curl https://getcaddy.com | bash -s git,mailout
#
# This should work on Mac, Linux, and BSD systems, and
# hopefully Windows with Cygwin. Please open an issue if
# you notice any bugs.
#
set -e


install_caddy()
{
	caddy_os="unsupported"
	caddy_arch="unknown"
	caddy_arm=""
	caddy_features="$1"
	install_path="/usr/local/bin"

	# Termux on Android has $PREFIX set which already ends with /usr
	if [[ -n "$ANDROID_ROOT" && -n "$PREFIX" ]]; then
		install_path="${PREFIX}/bin"
	fi

	# Fall back to /usr/bin if necessary
	if [ ! -d "${install_path}" ]; then
		install_path="/usr/bin"
	fi

	# Not every platform has or needs sudo (see issue #40)
	[[ $EUID -ne 0 && -z "$ANDROID_ROOT" ]] && sudo_cmd="sudo"


	#########################
	# Which OS and version? #
	#########################

	caddy_bin="caddy"
	caddy_dl_ext=".tar.gz"

	# NOTE: `uname -m` is more accurate and universal than `arch`
	# See https://en.wikipedia.org/wiki/Uname
	if [ -n "$(uname -m | grep aarch64)" ]; then
		caddy_arch="arm64"
	elif [ -n "$(uname -m | grep 64)" ]; then
		caddy_arch="amd64"
	elif [ -n "$(uname -m | grep 86)" ]; then
		caddy_arch="386"
	elif [ -n "$(uname -m | grep armv5)" ]; then
		caddy_arch="arm"
		caddy_arm="5"
	elif [ -n "$(uname -m | grep armv6l)" ]; then
		caddy_arch="arm"
		caddy_arm="6"
	elif [ -n "$(uname -m | grep armv7l)" ]; then
		caddy_arch="arm"
		caddy_arm="7"
	else
		echo "unsupported or unknown architecture"
		exit 1
	fi

	if [ "$(uname | grep -i 'Darwin')" ]; then
		caddy_os="darwin"
		caddy_dl_ext=".zip"
		OSX_VER="$(sw_vers | grep ProductVersion | cut -d':' -f2 | cut -f2)"
		OSX_MAJOR="$(echo ${OSX_VER} | cut -d'.' -f1)"
		OSX_MINOR="$(echo ${OSX_VER} | cut -d'.' -f2)"
		OSX_PATCH="$(echo ${OSX_VER} | cut -d'.' -f3)"

		# Major
		if [ "$OSX_MAJOR" -lt 10 ]; then
			echo "unsupported OS X version (9-)"
			exit 2
		fi
		if [ "$OSX_MAJOR" -gt 10 ]; then
			echo "unsupported OS X version (11+)"
			exit 2
		fi

		# Minor
		if [ "$OSX_MINOR" -le 5 ]; then
			echo "unsupported OS X version (10.5-)"
			exit 2
		fi
	elif [ "$(uname | grep -i 'Linux')" ]; then
		caddy_os="linux"
	elif [ "$(uname | grep -i 'FreeBSD')" ]; then
		caddy_os="freebsd"
	elif [ "$(uname | grep -i 'OpenBSD')" ]; then
		caddy_os="openbsd"
	elif [ "$(uname | grep -i 'WIN')" ]; then
		# Should catch cygwin
		caddy_os="windows"
		caddy_dl_ext=".zip"
		caddy_bin=${caddy_bin}.exe
	else
		echo "unsupported or unknown os"
		exit 3
	fi

	# Back up existing caddy, if any
	caddy_cur_ver="$(caddy --version 2>/dev/null | cut -d ' ' -f2)"
	if [ -n "${caddy_cur_ver}" ]; then
		# caddy of some version is already installed
		caddy_path="$(which caddy)"
		caddy_backup="${caddy_path}_${caddy_cur_ver}"
		echo "Backing up ${caddy_path} to ${caddy_backup}"
		echo "(Password may be required.)"
		$sudo_cmd mv "${caddy_path}" "${caddy_backup}"
	fi

	########################
	# Download and extract #
	########################


	echo "Downloading Caddy for ${caddy_os}/${caddy_arch}..."
	caddy_file="caddy_${caddy_os}_${caddy_arch}${caddy_arm}_custom${caddy_dl_ext}"
	caddy_url="https://caddyserver.com/download/build?os=${caddy_os}&arch=${caddy_arch}&arm=${caddy_arm}&features=${caddy_features}"
	echo "$caddy_url"

	# Use $PREFIX for compatibility with Termux on Android
	rm -rf "${PREFIX}/tmp/${caddy_file}"

	if [ -n "$(which curl)" ]; then
		curl -fsSL "$caddy_url" \
			-o "${PREFIX}/tmp/${caddy_file}"
	elif [ -n "$(which wget)" ]; then
		wget --quiet "$caddy_url" \
			-O "${PREFIX}/tmp/${caddy_file}"
	else
		echo "could not find curl or wget"
		exit 4
	fi

	echo "Extracting..."
	case "$caddy_file" in
	        *.zip)    unzip -o "${PREFIX}/tmp/${caddy_file}" "$caddy_bin" -d "${PREFIX}/tmp/" ;;
	        *.tar.gz) tar -xzf "${PREFIX}/tmp/${caddy_file}" -C "${PREFIX}/tmp/" "$caddy_bin" ;;
	esac
	chmod +x "${PREFIX}/tmp/${caddy_bin}"

	echo "Putting caddy in ${install_path} (may require password)"
	$sudo_cmd mv "${PREFIX}/tmp/${caddy_bin}" "${install_path}/${caddy_bin}"
	$sudo_cmd rm "${PREFIX}/tmp/${caddy_file}"

	# check installation
	$caddy_bin --version

	echo "Successfully installed"
	exit 0
}

install_caddy "$@"