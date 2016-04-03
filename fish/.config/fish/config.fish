#!/usr/bin/fish

function fish_prompt
    set EXIT_STATUS $status
    set USER (whoami)
    set HOST (hostname)
    set TIME (date +"%H:%M:%S")
    set CWD  (prompt_pwd)
	printf "[$USER@$HOST][$TIME][$CWD]"

    # show exist status of previous command
    if [ $EXIT_STATUS != 0 ]
        set_color red
        printf "[$EXIT_STATUS]"
        set_color normal
    end
    
    printf "\n> "
end

# squelch greeting
set fish_greeting ""

# aliases
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias opendirget='wget -e robots=off -r --level=0 -nc -np --reject html,htm,css'
alias ls="ls --color=never"

# setup environment variables
set -x PATH $HOME/bin $PATH
set -x CAD_ETC_PATH $HOME/etc
set -x CAD_BIN_PATH $HOME/bin
set -x PATH $PATH:$CAD_BIN_PATH
set -x EDITOR vim
set -x VISUAL vim


# fix intel gpu driver stuff
set hiz false
set INTEL_HIZ 0
set INTEL_SEPARATE_STENCIL 0
