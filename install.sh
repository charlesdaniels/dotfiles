#!/bin/sh

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

# vim-plug
curl -SsfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -SsfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# zsh-history-substring-search
curl -SsfLo ~/.zsh/zsh-history-substring-search.zsh --create-dirs \
    https://github.com/zsh-users/zsh-history-substring-search/raw/v1.0.1/zsh-history-substring-search.zsh

# zsh git completions
curl -SsfLo ~/.zsh/completions/git-completion.zsh --create-dirs \
    https://github.com/git/git/raw/v2.20.1/contrib/completion/git-completion.zsh

# zsh docker completions
curl -SsfLo ~/.zsh/completions/_docker-compose https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/zsh/_docker-compose 


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

# install fastabr
make -C "$DOTFILES_DIR/fastabr" fastabr
cp "$DOTFILES_DIR/fastabr/fastabr" ~/bin/fastabr

exit 0
