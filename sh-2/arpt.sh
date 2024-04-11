#!/usr/bin/env bash
# Author : imxieke
# Name   : apt (ArchLinux Repository And Package Tools)
# Time   : Friday March 32 2017
# Desc   : Build Archlinux Repository for person!
# License: Null
arptver=0.1
reponame=archapr
red="\e[0;31m"
nc="\e[0m"

    #if [[ `whoami` == "root" ]]; then
    #    echo "Don't Support Root, switch User Please."
    #    exit 1;
    #fi

    # Init User Base Packages
    init(){
        sudo pacman -Syy --noconfirm git vim zsh wget curl unzip
        
        # Install oh-my-zsh
        if [[ `curl -s ipinfo.io/country` == "CN" ]]; then
            echo "Country is CN"
            curl -s https://coding.net/u/imxieke/p/Collect/git/raw/master/Code/zsh.sh | bash
        else
            echo "Country is Oversea"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"        
        fi
    }
    
    #Build Package
    build(){
        pkg_dir=`pwd`/$2
        reponame=$1
        pkgname=$2
        cd $pkg_dir
        #Find PKGBUILD
        if [[ ! -f $pkg_dir/PKGBUILD ]]; then
            echo "PKGBUILD Not Exist."
            exit 1;
        else
            #Make Packages
            makepkg -s -c -r -f --noconfirm --skipchecksums --skippgpcheck
        fi
    }
    
    ## Build Repo Package  From Aur
    gen(){
        
        repo_dir=`pwd`/$2
        cd $repo_dir
        
        if [[ `ls |grep pkg.tar.xz` == "" ]]; then
            echo "Not Found Package File"
            exit 1;
        fi
        
        repo-add ${reponame}.db.tar.xz *.pkg.tar.xz
    }
    
    ## Build All Repo Package  From Aur
    genall(){
        repo_dir=`pwd`
        cd $repo_dir/any && repo-add archapr-any.db.tar.xz *.pkg.tar.xz
        cd $repo_dir/aarc64 && repo-add archapr-aarch64.db.tar.xz *.pkg.tar.xz
        cd $repo_dir/x86_64 && repo-add archapr-x86_64.db.tar.xz *.pkg.tar.xz
    }
    
    # Init User and passwd
    inituser(){
        USER=$2
        PASS=$3
        useradd -d /home/$USERNAME -m $USERNAME -s /bin/bash
        echo "$USERNAME:$PASS" |chpasswd
        echo "root:$PASS" | chpasswd
        echo "$USERNAME ALL=NOPASSWD: ALL" >>/etc/sudoers
        echo "------------------------------------------------------------------"
        echo "Username: $USER password: '$PASS'					"
        echo "Please remember to change the above password as soon as possible!	"
        echo "------------------------------------------------------------------"
    }

case $1 in

    build|b|-b )
        build $1 $2 $3 $4 $5
        ;;

    gen|g|-g )
        gen $1 $2 $3 $4 $5
        ;;

    genall|-G )
        genall $1 $2 $3 $4 $5
        ;;
        
    init|i|-i )
        init $1 $2 $3 $4 $5
        ;;

    inituser|-I)
        inituser $1 $2 $3 $4 $5
        ;;
        
    help|-h|--help )
        clear
        echo ""
        echo ""
        echo "--------------------------------------------------"
        echo -e "$red      ArchLinux Aur Tools               $nc"
        echo ""
        echo "-i init          - Init env for Base Tools       "
        echo "-I inituser      - Init User(Add Non-Root User) For Build"
        echo "-b build         - Build Package,No manual intervention  "
        echo "-g gen           - Build Person Repository.       "
        echo "-G genall        - Build All Repository           "
        echo "-v version       - Show Version                   "
        echo "--------------------------------------------------"
        echo ""
        echo ""
        ;;
    version|v|-v|-V )
        echo "v"$arptver
        ;;
        
    *)
        clear
        echo ""
        echo ""
        echo -e "$red Unknown Command,Try Again $nc"
        echo "Current Command : `basename $0` $1 $2 $3 $4 $5"
        echo "Usage: `basename $0` [init|build|gen|genall]"
        echo ""
        echo ""
        ;;
esac
