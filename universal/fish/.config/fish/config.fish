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
if command -v micro
	set -gx EDITOR vim
	set -gx VISUAL vim
else
	set -gx EDITOR micro
	set -gx VISUAL micro
end

if test -e $HOME/bin
	set -gx PATH $HOME/bin $PATH 
end

if test -e $HOME/.go-workspace
	set -gx GOPATH "$HOME/.go-workspace"
	set -gx PATH $GOPATH/bin $PATH
end 

if test -e /usr/local/sbin
	set -gx PATH "/usr/local/sbin" $PATH
end

if test -e /opt.local/bin
	set -gx PATH "/opt/local/bin" $PATH
end

if test -e /usr/local/bin
	set -gx PATH "/usr/local/bin" $PATH
end 

if test -e /opt/net.cdaniels/bin
  set -gx PATH "/opt/net.cdaniels/bin/ $PATH
end 


test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
