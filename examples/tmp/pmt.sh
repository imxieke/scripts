#!/usr/bin/env bash

# pmt: Package Manage Tool for linux

NAME='pmt'
VERSION='0.1.1'
DESCIPTION='Simple Package Manage Tool for linux'

PMT_PATH='/var/lib/pmt'
PKG_PATH=${PMT_PATH}/packages
LOG_PATH=${PMT_PATH}/logs

STATS_LOG=${LOG_PATH}/stats.log 		# stat package install and update info
INSTALL_LOG=${LOG_PATH}/install.log 	# record install log
UPDATE_LOG=${LOG_PATH}/update.log 		# record update log
UNINSTALL_LOG=${LOG_PATH}/update.log 	# record uninstall log

function _check_env()
{
	if [[ ! -d ${PMT_PATH} ]]; then
		mkdir -p ${PMT_PATH}
	fi

	if [[ ! -d ${PKG_PATH} ]]; then
		mkdir -p ${PKG_PATH}
	fi

	if [[ ! -d ${LOG_PATH} ]]; then
		mkdir -p ${LOG_PATH}
	fi

	if [[ ! -f ${STATS_LOG} ]]; then
		touch ${STATS_LOG}
	fi

	if [[ ! -f ${INSTALL_LOG} ]]; then
		touch ${STATS_LOG}
	fi

	if [[ ! -f ${UPDATE_LOG} ]]; then
		touch ${UPDATE_LOG}
	fi

	if [[ ! -f ${UNINSTALL_LOG} ]]; then
		touch ${UNINSTALL_LOG}
	fi
}

