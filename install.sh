#!/bin/sh

set -e
set -u

# install overlay
cd "$(dirname "$0")"
DOTFILES_DIR="$(pwd)"
OVERLAY_DIR="$DOTFILES_DIR/overlay"
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

# zsh-history-substring-search
if [ ! -d "./zsh-history-substring-search" ] ; then
	git clone --quiet git://github.com/zsh-users/zsh-history-substring-search.git
fi
cd zsh-history-substring-search
git reset --hard HEAD --quiet
git pull --quiet origin master
cd "$ZSH_DIR"
rm -f ./zsh-history-substring-search.zsh
ln -s ./zsh-history-substring-search/zsh-history-substring-search.zsh ./zsh-history-substring-search.zsh

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
curl -SsfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -SsfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# setup gitconfig
git_username="$(git config --get user.name)"
git_email="$(git config --get user.email)"
git_config_file="$HOME/.gitconfig"
rm -f "$git_config_file"
echo '[user]' >> "$git_config_file"
echo "    name = $git_username" >> "$git_config_file"
echo "    email = $git_email" >> "$git_config_file"
echo "" >> "$git_config_file"
cat "$DOTFILES_DIR/gitconfig" >> "$git_config_file"

# setup nowall
cd "$DOTFILES_DIR/nowall"
make
cp ./nowall ~/bin/nowall



exit 0
