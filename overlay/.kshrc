. ~/.profile

export PS1='$(whoami)@$(hostname | cut -d. -f1):$(fastabr) > '
set -o vi
