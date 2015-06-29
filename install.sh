#!/bin/bash

#make sure stow is installed
apt-get -y install stow

# setup bash, vim, scripts and tmux
apt-get -y install vim tmux

stow bash
stow scripts
stow tmux
stow vim

cd ~

bash
