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
HISTSIZE=10000
# place to store them
HISTFILE=~/.zsh_history
# lines to store on disk
SAVEHIST=1000000
# append history to file without writing
setopt appendhistory
# share history across sessions
setopt sharehistory
# immediately append history lines, rather then on session close
setopt incappendhistory
# bash globbing behavior
setopt NO_NOMATCH

# use keybindings that aren't stupid
bindkey -e

# make sure perms on ~/.zsh are ok (WSL likes to reset them)
chmod -R 755 ~/.zsh

# git completions
fpath=(~/.zsh $fpath)
# http://stackoverflow.com/a/26479426
autoload -U compinit && compinit
zmodload -i zsh/complist

# k
source ~/.zsh/k.sh

# zcalc calculator
autoload -U zcalc
zle -N zcalc

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
		VISTATE="I"
	elif [ "$KEYMAP" = "vicmd" ] ; then
		VISTATE="N"
	else
		VISTATE="$KEYMAP"
	fi
	zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

# edit the current line in vim with ^V
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

# make backspace work as expected in insert mode
bindkey "^?" backward-delete-char

# allow the text inside quotes motion to work
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
	for c in {a,i}{\',\",\`}; do
		bindkey -M $m $c select-quoted
	done
done

# and inside of brackets
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M $m $c select-bracketed
	done
done

function nios2eds_status_disp {
	# Detect when we are in a NIOS2 development environment and update
	# the prompt to indicate this.
	if [ -d "$SOPC_KIT_NIOS2" ] ; then
		printf "nios2/"
	else
		printf ""
	fi
}

export PROMPT='$(echo -en "\033]0;zsh\a")[%n@%M][%T][$VISTATE][$(felix_pwd_abbr)]
($(nios2eds_status_disp)zsh) $ '


# zsh autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh syntax highlighting
# MUST BE THE LAST THING SOURCED
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
