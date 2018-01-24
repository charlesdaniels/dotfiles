#!/usr/bin/fish

source $HOME/.config/fish/fish-prompt.fish

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
if command -v micro > /dev/null
	set -gx EDITOR micro
	set -gx VISUAL micro
else
	set -gx EDITOR vim
	set -gx VISUAL vim
end

set -gx GOPATH "$HOME/.go-workspace" 

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish


if test -d "$HOME/bin"
    set -gx PATH $HOME/bin $PATH
end
if test -d "$HOME/.go-workspace/bin"
    set -gx PATH $HOME/.go-workspace/bin $PATH
end
if test -d "$HOME/.net.cdaniels.toolchest/bin"
    set -gx PATH $HOME/.net.cdaniels.toolchest/bin $PATH
end
if test -d "$HOME/.net.cdaniels.toolchest/local/bin"
    set -gx PATH $HOME/.net.cdaniels.toolchest/local/bin $PATH
end
if test -d "/opt/bin"
    set -gx PATH /opt/bin $PATH
end
if test -d "/opt/local/bin"
    set -gx PATH /opt/local/bin $PATH
end
if test -d "/opt/net.cdaniels/bin"
    set -gx PATH /opt/net.cdaniels/bin $PATH
end

