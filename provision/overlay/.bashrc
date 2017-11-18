# Setup for my custom paths
. $HOME/.profile

if [ "$TERM" == "xterm-termite" ] ; then
  export TERM="xterm"
fi

export PS1="[\u@\h][\A][\w]\n(bash) $ \[$(tput sgr0)\]"

# git completion
source ~/.git-completion.bash
