# Setup for my custom paths
export CAD_ETC_PATH=$HOME/etc
export CAD_BIN_PATH=$HOME/bin
export PATH=$PATH:$CAD_BIN_PATH
export EDITOR=vim
export VISUAL=vim

if [ "$TERM" == "xterm-termite" ] ; then
  export TERM="xterm"
fi 

export PS1="[\u@\h][\A][\w]\n\\$ \[$(tput sgr0)\]"