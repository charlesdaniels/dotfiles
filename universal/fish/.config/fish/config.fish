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
alias ls="ls --color=never"




# fix intel gpu driver stuff
set hiz false
set INTEL_HIZ 0
set INTEL_SEPARATE_STENCIL 0


switch (echo $TERM)
case xterm-termite
	set TERM 'xterm'
case '*'
	# do nothing
end

functions --erase ls # prevents ls from breaking on BSD

# setup environment variables
set -x PATH $HOME/bin $PATH
set -x GOPATH "$HOME/.go-workspace"
set -x PATH $GOPATH/bin $PATH
set -x PATH "/usr/local/sbin" $PATH
set -x PATH "/opt/local/bin" $PATH
set -x PATH "/usr/local/bin" $PATH

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
