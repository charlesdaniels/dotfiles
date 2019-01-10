. /etc/profile
clear
# on Ubuntu, /etc/profile throws a bunch of errors, so we clear the screen

export EDITOR=v
export VISUAL=v
export GOPATH=$HOME/.go-workspace

export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.go-workspace/bin:$PATH
export PATH=$HOME/.net.cdaniels.toolchest/bin:$PATH
export PATH=$HOME/.net.cdaniels.toolchest/local/bin:$PATH
export PATH=/opt/bin:$PATH
export PATH=/opt/local/bin:$PATH
export PATH=/opt/net.cdaniels/bin:$PATH
export PATH=/snap/bin/:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/esp/xtensa-esp32-elf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/cxoffice/bin:$PATH"

export TEXMFHOME="$HOME/.texmf"

export IDF_PATH="$HOME/.local/share/esp/esp-idf"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# this fixes missing color support in neovim
export COLORTERM=xterm-256color

export MANPATH="$MANPATH:$HOME/.local/man"

# export ENV for ksh
export ENV=$HOME/.kshrc
