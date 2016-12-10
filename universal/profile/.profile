export EDITOR=vim
export VISUAL=vim
export PATH="$HOME"/bin:"$PATH"
export GOPATH=$HOME/.go-workspace
if [ -e "$GOPATH" ] ; then
  export PATH=$GOPATH/bin:$PATH
fi
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=/opt/net.cdaniels/bin:$PATH
export PATH=/Library/TeX/texbin/:$PATH
export PATH=$PATH:/opt.net.cdaniels.toolchest/bin
export PATH=$PATH:/opt/net.cdaniels.toolchest/local/bin
export PATH=$PATH:$HOME/.net.cdaniels.toolchest/bin
export PATH=$PATH:$HOME/.net.cdaniels.toolchest/local/bin

# source global shell variables
source $HOME/dotfiles/lib/configs/MASTER.CFG