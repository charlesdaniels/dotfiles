# Setup for my custom paths
export CAD_ETC_PATH=$HOME/etc
export CAD_BIN_PATH=$HOME/bin
export PATH=$CAD_BIN_PATH:$PATH
export EDITOR=vim
export VISUAL=vim

if [ "$TERM" == "xterm-termite" ] ; then
  export TERM="xterm"
fi 

export PS1="[\u@\h][\A][\w]\n\\$ \[$(tput sgr0)\]"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias ls="ls --color=never"