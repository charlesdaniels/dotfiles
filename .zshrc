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
export PATH=$HOME/.net.cdaniels.toolchest/bin:$PATH
export PATH=$HOME/.net.cdaniels.toolchest/local/bin:$PATH


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

# use keybindings that aren't stupid
bindkey -e

# make sure perms on ~/.zsh are ok (WSL likes to reset them)
chmod -R 755 ~/.zsh

# git completions
fpath=(~/.zsh $fpath)
# http://stackoverflow.com/a/26479426
autoload -U compinit && compinit
zmodload -i zsh/complist

# zsh autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh syntax highlighting 
# MUST BE THE LAST THING SOURCED
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

