# Created by newuser for 5.0.7

# Setup for my custom paths
export EDITOR=vim
export VISUAL=vim
export PATH=$PATH:$HOME/bin
export GOPATH=$HOME/.go-workspace
export PATH=$PATH:$GOPATH/bin
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
export PATH=$PATH:/Library/TeX/texbin/
export PATH=$PATH:/opt.net.cdaniels.toolchest/bin
export PATH=$PATH:/opt/net.cdaniels.toolchest/local/bin
export PATH=$PATH:$HOME/.net.cdaniels.toolchest/bin
export PATH=$PATH:$HOME/.net.cdaniels.toolchest/local/bin


if [ "$TERM" = "xterm-termite" ] ; then
  export TERM="xterm"
fi 

PS1='[%n@%M][%T][%~]
(zsh) $ '
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# zsh specific settings
# immediately show amgiguous completions
set show-all-if-ambiguous on
# ignore case for completions
set completion-ignore-case on
# disable correction
unsetopt correct_all
# lines of history to store
HISTSIZE=1000
# place to store them
HISTFILE=~/.zsh_history
# lines to store on disk
SAVEHIST=1000
# append history to file without writing
setopt appendhistory
# share history across sessions
setopt sharehistory
# immediately append history lines, rather then on session close
setopt incappendhistory

# use autocompletion, if supported
which acquire-toolchest-dirs | grep acquire-toolchest-dirs > /dev/null
if [ $? -eq 0 ] ; then
  $(acquire-toolchest-dirs)
  AUTOSUGGESTIONS_PATH="$NET_CDANIELS_TOOLCHEST_LOCAL/lib/zsh-autosuggestions/src"
  SYNTAX_HIGHLIGHTING_PATH="$NET_CDANIELS_TOOLCHEST_LOCAL/lib/zsh-syntax-highlighting/src"
  if [ -e "$AUTOSUGGESTIONS_PATH" ] ; then
    source "$AUTOSUGGESTIONS_PATH/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
  fi
  # zsh syntax highlighting has to be sourced last
  if [ -e "$SYNTAX_HIGHLIGHTING_PATH" ] ; then
    source "$SYNTAX_HIGHLIGHTING_PATH/zsh-syntax-highlighting.zsh"
  fi
fi
