. ~/.profile

export PS1='$(whoami)@$(hostname | cut -d. -f1):$(fastabr) > '
set -o vi

# shell history file
HISTFILE="$HOME/.ksh_history"
HISTSIZE=5000
