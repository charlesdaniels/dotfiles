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
