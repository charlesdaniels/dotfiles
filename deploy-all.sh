#!/bin/bash

# Deploy all dotfiles, and also setup some packages

DOTFILESDIR=$HOME/dotfiles 

installpackage ()
{
	sudo pacman -S "$@" # change to sudo apt-get install for .deb based systems 
}


# deploy configs
cd $DOTFILESDIR
stow bash
stow bin
stow i3
stow subl
stow termite
stow tmux
stow vim

# install packages
installpackage vim tmux htop nano nmap ioping xbindkeys xdotool 
