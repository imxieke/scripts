#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-23 15:01:11
 # @LastEditTime: 2021-12-24 14:32:18
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /scripts/sh/archlinux-desktop.sh
### 

# mirrors
# https://archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4

INPUT_METHOD DEFAULT=fcitx5
export INPUT_METHOD=fcitx
GTK_IM_MODULE DEFAULT=fcitx5
QT_IM_MODULE DEFAULT=fcitx5
XMODIFIERS DEFAULT=\@im=fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# Depends
pacman -S --noconfirm libcurl-gnutls

pacman -S --noconfirm gdm
systemctl enable gdm.service

pacman -S --noconfirm plasma
# pacman -S --noconfirm deepin deepin-extra
# pacman -S --noconfirm gnome gnome-extra
# pacman -S --noconfirm mate mate-extra
# pacman -S --noconfirm ukui
# pacman -S --noconfirm xfce4 xfce4-goodies
# pacman -S --noconfirm gnome gnome-tweak-tool

# KDE Components
pacman -S --noconfirm dolphin kcron khelpcenter ksystemlog partitionmanager grantlee-editor kontact kleopatra kmail kmail-account-wizard knotes pim-data-exporter akregator zanshin kamoso
pacman -S --noconfirm ark filelight kate kbackup kcalc kcharselect kdf kdialog kfind kfloppy kgpg kteatime ktimer kwalletmanager kwrite markdownpart sweeper svgpart spectacle okular gwenview kcolorchooser kimagemapeditor svgpart dolphin-plugins

# Math
pacman -S --noconfirm cantor

# Talking
# konversation full-featured IRC Client
pacman -S --noconfirm konversation


# KDE Games
pacman -S --noconfirm kde-games

# Sound Driver
pacman -S --noconfirm alsa-utils pulseaudio-alsa

# 笔记本触摸板驱动 台式机用不到
# pacman -S xf86-input-libinput

systemctl enable NetworkManager

# Input Method
pacman -S --noconfirm fcitx fcitx-im fcitx-configtool fcitx-googlepinyin fcitx5-chinese-addons fcitx5-qt fcitx5-gtk

# fonts
pacman -S noto-fonts-cjk wqy-microhei wqy-microhei-lite wqy-bitmapfont ttf-consolas-with-yahei
pacman -S wqy-zenhei ttf-arphic-ukai ttf-arphic-uming adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
fonts-wqy-microhei fonts-wqy-zenhei awesome-terminal-fonts

fc-cache -fv

# macOS style dock
pacman -S --noconfirm plank
# 用不到系列
# deepin-diskmanager deepin-draw deepin-voice-note
# 卡顿
# deepin-picker
# 非 Deepin 桌面有过多依赖
# deepin-file-manager

pacman -S --noconfirm deepin-terminal deepin-album deepin-calculator deepin-compressor deepin-editor deepin-font-manager 
deepin-image-viewer deepin-mail deepin-movie deepin-music deepin-reader deepin-screen-recorder deepin-store deepin-system-monitor
deepin-wallpapers-manjaro
deepin-wallpapers-plasma
deepin-community-wallpapers

# Design
# krita
# Edit and paint images
# kwave sound editor
pacman -S --noconfirm krita kolourpaint

# Downloader
# ktorrent A powerful BitTorrent client for KDE
pacman -S --noconfirm kget ktorrent

# MultiMedia
pacman -S --noconfirm dragon elisa

# Network && Browser
pacman -S --noconfirm konqueror

yay -S google-chrome netease-cloud-music ttf-wps-fonts wps-office wps-office-mui-zh-cn wps-office-mime-cn ttf-ms-fonts cups

# Remote Desktop Manager
# krdc Remote Desktop Client
# krfb Desktop Sharing
pacman -S --noconfirm remmina freerdp krdc krfb

# Tools
# kompare Graphical file differences tool
pacman -S --noconfirm screen asciinema kompare dpkg

# Terminal
pacman -S --noconfirm deepin-terminal gnome-terminal konsole mate-terminal

# Third-Party Software
pacman -S --noconfirm snapd flatpak

# Wine
pacman -S --noconfirm wine wine-gecko wine-mono winetricks vkd3d
pacman -S --noconfirm playonlinux

# Archive Compress
# unarchiver unar lsar
pacman -S --noconfirm unarchiver