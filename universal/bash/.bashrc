# Setup for my custom paths
export EDITOR=vim
export VISUAL=vim
export PATH=$PATH:$HOME/bin
export GOPATH=$HOME/.go-workspace
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/opt/local/bin
export PATH=$PATH:/opt/local/sbin
export PATH=$PATH:/Library/TeX/texbin/
export PATH=$PATH:/opt.net.cdaniels.toolchest/bin
export PATH=$PATH:/opt/net.cdaniels.toolchest/local/bin
export PATH=$PATH:$HOME/.net.cdaniels.toolchest/bin
export PATH=$PATH:$HOME/.net.cdaniels.toolchest/local/bin


if [ "$TERM" == "xterm-termite" ] ; then
  export TERM="xterm"
fi 

export PS1="[\u@\h][\A][\w]\n\\$ \[$(tput sgr0)\]"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# source global shell variables
source $HOME/dotfiles/lib/configs/MASTER.CFG