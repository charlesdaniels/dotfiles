#!/usr/bin/fish

source $HOME/.config/fish/add-to-path.fish
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

add-to-path $HOME/bin
add-to-path $GOPATH/bin
add-to-path "/usr/local/sbin"
add-to-path "/opt/local/bin"
add-to-path "/usr/local/bin"
add-to-path "/opt/net.cdaniels/bin/"
add-to-path "/Library/TeX/texbin/"
add-to-path "/opt.net.cdaniels.toolchest/bin"
add-to-path "/opt/net.cdaniels.toolchest/local/bin"
add-to-path "$HOME/.net.cdaniels.toolchest/bin"
add-to-path "$HOME/.net.cdaniels.toolchest/local/bin"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish


