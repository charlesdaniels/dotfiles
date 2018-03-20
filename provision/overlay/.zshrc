. "$HOME/.profile"

if [ "$TERM" = "xterm-termite" ] ; then
  export TERM="xterm"
fi

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

# k
source ~/.zsh/k.sh

# vim keybindings
bindkey -v
export KEYTIMEOUT=1 # 0.1s

# pull in path abbreviation
source ~/.zsh/abbr_pwd.zsh

# allow command expansion in the prompt
setopt PROMPT_SUBST

# Keep the VISTATE variable updated and force the prompt to redraw when
# entering or leaving vi editing modes
function zle-line-init zle-keymap-select {
	if [ "$KEYMAP" = "main" ] ; then
		VISTATE="INSERT"
	elif [ "$KEYMAP" = "vicmd" ] ; then
		VISTATE="NORMAL"
	else
		VISTATE="UNKNOWN ($KEYMAP)"
	fi
	zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

# edit the current line in vim with ^V
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

export PROMPT='[%n@%M][%T][$VISTATE][$(felix_pwd_abbr)]
(zsh) $ '

# zsh syntax highlighting
# MUST BE THE LAST THING SOURCED
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

