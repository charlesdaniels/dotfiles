. "$HOME/.profile"

if [ "$TERM" = "xterm-termite" ] ; then
  export TERM="xterm"
fi

PS1='[%n@%M][%T][%~]
(zsh) $ '

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
