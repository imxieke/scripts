#!/usr/bin/env bash

NAME="neofetch"
VERSION='6.0.1'
TYPE='file'
URL='https://github.com/dylanaraps/neofetch/raw/master/neofetch'
PREFIX=/usr
MANDIR=${PREFIX}/share/man

function download()
{
	echo "=> Fetch ${NAME} fiel"
	mkdir -p /tmp/packages/${NAME}
	curl -sSLo /tmp/packages/${NAME}/${NAME} ${URL}
	curl -sSLo /tmp/packages/${NAME}/${NAME}.1 ${URL}.1
	echo "${NAME} resource fetch complete "
}

function install()
{
	echo "=> Start Install ${NAME} ${VERSION}"
	mkdir -p ${PREFIX}/bin
	mkdir -p ${MANDIR}/man1
	mv /tmp/packages/${NAME}/${NAME} ${PREFIX}/bin/neofetch
	mv /tmp/packages/${NAME}/${NAME}.1 ${MANDIR}/man1
	chmod 755 ${PREFIX}/bin/neofetch
	echo "=> ${NAME} install complete "
}

function uninstall()
{
	echo "=> Start uninstall ${NAME} ${VERSION}"
	rm -rf ${PREFIX}/bin/${NAME}
	rm -rf ${MANDIR}/man1/neofetch.1*
	echo "=> ${NAME} uninstall complete "
}

case $1 in
	install )
		download
		install
		;;
	uninstall)
		uninstall
		;;
	*)
		echo "Usage: install | uninstall"
		;;
esac
