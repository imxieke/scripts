#!/usr/bin/env bash
#Author: imxieke
#Time  : Fri 2/10/2012
#Descript: the script for easy to use Debian-like OS(base debian distribution) package manage! ### For me ###

VERSION=0.01
DL_URL=https://coding.net/u/imxieke/p/Collect/git/raw/master/Code/xpm.sh

case $1 in
    autoremove)
        apt-get autoremove $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    build-dep)
        apt-get build-dep $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    changelog)
        apt-get changelog $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    check)
        apt-get check $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    dl)
        apt-get download $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    edit)
        apt edit-sources $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    install)
        apt-get install  $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    list)
        apt list $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    remove)
        apt-get remove $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    repair)
        rm -fr /var/cache/apt/archives/lock && rm -fr /var/lib/dpkg/lock
    
    search)
        apt search $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    show)
        apt show $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    source)
        apt-get source $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    update)
        apt update $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    up-self)
        curl -s $DL_URL >/tmp/xpm && chmod +x /tmp/xpm
        NEW_VERSION=$(/tmp/xpm -v)
        if [[ "$NEW_VERSION" > "0.9" ]]; then
            echo "Have New Version"
            read -p "Please confirm to update latest version: y/n " update_connfirm
            if [[ "$update_connfirm" = "y" ]] || [[ "$update_connfirm" = "Y" ]] ; then
                mv /tmp/xpm /bin/xpm
                echo "xpm has been successfully update to latest version: $NEW_VERSION "
            else
                echo "Operation Cancelled"
            fi
        elif [[ "$NEW_VERSION" = "$VERSION" ]]; then
            echo "don't have new version xpm "
        else
            echo "update fail, please try again!"
        fi
        ;;
        
    upgrade)
        apt upgrade $2 $3 $4 $5 $6 $7 $8 $9
        ;;
        
    full-upgrade)
        apt full-upgrade
        ;;
        
    dist-upgrade)
        apt-get dist-upgrade
        ;;
        
    help|-h|--help|-H)
        echo "#################################################################################"
	    echo "                      XPM Help Document                                          "
	    echo "#################################################################################"
	    echo "autoremove    - automatically Remove all unused packages"
        echo "build-dep     - Configure build-dependencies for source packages"
	    echo "check         - Verify that there are no broken dependencies"
	    echo "changelog     - Download and display the changelog for the given package"
	    echo "dist-upgrade  - Distribution upgrade, see apt-get(8)"
	    echo "dl            - Download the binary package into the current directory"
	    echo "edit          - dit the source information file(sources.list)"
	    echo "install       - Install new packages"
	    echo "list          - list packages based on package names"
	    echo "full-upgrade  - upgrade the system by removing/installing/upgrading packages"
	    echo "remove        - remove packages"
	    echo "repair        - repair for apt update lock error"
	    echo "search        - Search in package descriptions"
	    echo "show          - Show package details"
	    echo "source        - Download source archives"
	    echo "update        - update all packages to newest"
	    echo "upgrade       - upgrade the system by installing/upgrading packages"
	    echo "up-self       - update xpm Script Pragram"
	    echo "help|-h       - show xpm help document"
	    echo "version|-v    - show xpm version info "
	    echo "################################################################################"
	    ;;
	    
    version|-v)
        echo "$VERSION"
        ;;
        
    *)
        echo "Unknow Option:" $1 $2 $3 $4 $5 $6 $7 $8 $9
        ;;
esac