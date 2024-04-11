#!/usr/bin/env bash
echo "Start install zsh"
apt install zsh -y && \
sh -c "$(curl -fsSL https://coding.net/u/imxieke/p/oh-my-zsh/git/raw/master/tools/install.sh)"