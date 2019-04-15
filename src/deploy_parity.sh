#!/usr/bin/env bash
# Onekey Install Parity (Ethereum Wallet)

saveDir='/opt/parity'
dataDir=${saveDir}/'data'

if [[ ! -d ${saveDir} ]]; then
	sudo mkdir -p ${saveDir}
fi

if [[ ! -d ${dataDir} ]]; then
	sudo mkdir -p ${dataDir}
fi

function latest_version()
{
	VERSION=$(curl -sI https://github.com/paritytech/parity-ethereum/releases/latest | grep Location | awk -F '/v' '{print $2}')
	echo ${VERSION}
}

function get_download_url()
{
		# URL="https://releases.parity.io/ethereum/v$(latest_version)/x86_64-unknown-linux-gnu/parity"
		URL=$(curl -sL https://github.com/paritytech/parity-ethereum/releases/latest | grep x86_64-unknown-linux-gnu/parity | awk -F '"' '{print $4}')
		echo ${URL}
}

# latest_version
# get_download_url

function install_parity()
{
	echo "Current Version" $(latest_version)
	echo "=> Downloading Parity ... "
	if [[ -f '/opt/parity/parity' ]]; then
		echo "look like has been installed, skip it"
	else
		sudo wget $(get_download_url) -O /opt/parity/parity
		sudo chmod +x /opt/parity/parity
		sudo ln -s /opt/parity/parity /bin/parity
	fi
	echo "Install Success , start help with /opt/parity/parity -h "
}

function reinstall_parity()
{
	echo "Current Version" $(latest_version)
	echo "=> Downloading Parity ... "
	if [[ -f '/opt/parity/parity' ]]; then
		sudo rm -fr /opt/parity/parity
		sudo wget $(get_download_url) -O /opt/parity/parity
		sudo chmod +x /opt/parity/parity
		sudo ln -s /opt/parity/parity /bin/parity
	else
		echo "Parity Look like Not Install ,skip it"
	fi
	echo "Install Success , start help with /opt/parity/parity -h "
}

function upgrade_parity()
{
	echo "Current Version" $(latest_version)
	echo "=> Downloading Parity ... "
	if [[ -f '/opt/parity/parity' ]]; then
		sudo rm -fr /opt/parity/parity
		sudo wget $(get_download_url) -O /opt/parity/parity
		sudo chmod +x /opt/parity/parity
		sudo ln -s /opt/parity/parity /bin/parity
	else
		echo "Parity Look like Not Install ,skip it"
	fi
	echo "Install Success , start help with /opt/parity/parity -h "
}

function start ()
{
	nohup /opt/parity/parity --jsonrpc-interface 0.0.0.0 --jsonrpc-apis eth,net,web3,personal,parity --jsonrpc-port 8545 --jsonrpc-cors 0.0.0.0 --base-path /opt/parity/data/ 2>&1 | tee parity.log &
	echo "Parity has Started"
}

case $1 in
	version | -v )
		/opt/parity/parity -v | grep version\ Parity | awk -F ' ' '{print $2}'
		;;
	latest-version )
		latest_version
		;;
	install )
		install_parity
		;;
	reinstall )
		reinstall_parity
		;;
	upgrade )
		upgrade_parity
		;;
	* )
		echo "Command usage: install | reinstall | upgrade | version | latest-version  "
		;;
esac
