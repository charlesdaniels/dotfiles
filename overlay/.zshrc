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
fpath=(~/.zsh/completions $fpath)

# http://stackoverflow.com/a/26479426
autoload -U compinit && compinit
zmodload -i zsh/complist

# zcalc calculator
autoload -U zcalc
zle -N zcalc

# vim keybindings
bindkey -v
export KEYTIMEOUT=1 # 0.1s

# allow command expansion in the prompt
setopt PROMPT_SUBST

# Keep the VISTATE variable updated and force the prompt to redraw when
# entering or leaving vi editing modes
function zle-line-init zle-keymap-select {
	if [ "$KEYMAP" = "main" ] ; then
		VISTATE=">"
	elif [ "$KEYMAP" = "vicmd" ] ; then
		VISTATE=":"
	else
		VISTATE="$KEYMAP"
	fi
	
	# fix home/end
	echoti smkx
	zle reset-prompt
}

# fix home/end
function zle-line-finish () { echoti rmkx }

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# fix ^Y / ^E showing up when scrolling in st
function do_nothing () {printf ""}
zle -N do_nothing
bindkey '^Y' do_nothing
bindkey '^E' do_nothing

# zsh history substring search
source ~/.zsh/zsh-history-substring-search.zsh

# fix a breakage in zsh introduced by Debian's packaging
# https://github.com/robbyrussell/oh-my-zsh/issues/1720#issuecomment-22921247
# note: it's unclear if this does anything helpful?
export DEBIAN_PREVENT_KEYBOARD_CHANGES=yes

# bind to up and down arrows
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-substring-search-up
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-substring-search-down

# and also to j and k in normal mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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

export SHORT_HOSTNAME="$(hostname | cut -d'.' -f1)"

export PROMPT='%n@$SHORT_HOSTNAME:$(fastabr) $VISTATE '
