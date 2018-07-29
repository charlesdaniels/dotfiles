#!/bin/sh

set -e
set -u

# install overlay

OVERLAY_DIR="$(dirname "$0")/overlay"
DEST_DIR="$HOME"

cd "$OVERLAY_DIR"

find . -type f | while read -r target ; do
	target_relparent="$(dirname "$target")"
	dest_parent="$DEST_DIR/$target_relparent"
	dest_file="$DEST_DIR/$target"
	rm -f "$dest_file"
	mkdir -p "$dest_parent"
	cp "$target" "$dest_file"
done

# install shell extensions

# ensure the directory exists
ZSH_DIR="$HOME/.zsh"
if [ ! -d "$ZSH_DIR" ] ; then
	mkdir -p "$ZSH_DIR"
fi
if [ ! -d "$ZSH_DIR" ] ; then
	echo "FATAL: could not create $ZSH_DIR"
	exit 1
fi
cd "$ZSH_DIR"

# zsh fast syntax highlighting
if [ ! -d "./fast-syntax-highlighting" ] ; then
	git clone --quiet git://github.com/zdharma/fast-syntax-highlighting.git
fi
cd fast-syntax-highlighting
git reset --hard HEAD --quiet
git pull --quiet origin master
cd "$ZSH_DIR"

# zsh-autosuggestions
if [ ! -d "./zsh-autosuggestions" ] ; then
	git clone --quiet git://github.com/zsh-users/zsh-autosuggestions.git
fi
cd zsh-autosuggestions
git reset --hard HEAD --quiet
git pull --quiet origin master
cd "$ZSH_DIR"

# zsh-abbr-path
if [ ! -d "./zsh-abbr-path" ] ; then
	git clone --quiet git://github.com/felixgravila/zsh-abbr-path.git
fi
cd zsh-abbr-path
git reset --hard HEAD --quiet
git pull --quiet origin master
cd "$ZSH_DIR"
rm -f ./abbr_pwd.zsh
ln -s ./zsh-abbr-path/.abbr_pwd ./abbr_pwd.zsh

# git completions
rm -f "$HOME/.git-completion.bash"
rm -f "$HOME/.git-completion.zsh"
BASE_URL='https://raw.githubusercontent.com/git/git/master/contrib/completion'
curl -LSs "$BASE_URL/git-completion.bash" -o "$HOME/.git-completion.bash"
curl -LSs "$BASE_URL/git-completion.zsh" -o "$HOME/.git-completion.zsh"

# vim-plug
curl -SsfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
