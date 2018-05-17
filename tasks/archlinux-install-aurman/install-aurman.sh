#!/bin/sh

if [ -n "$(pacman -Qs aurman)" ]; then
	# already installed
	echo "aurman is already installed"
	exit 0
fi

TMP_DIR="/tmp/taskutil-install-aurman-$(uuidgen)"
mkdir -p "$TMP_DIR"

cd "$TMP_DIR"

# get sudo auth
echo "$TASKUTIL_SUDO_PASSWORD" | sudo -S date

curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=aurman
makepkg PKGBUILD --install --needed

cd "$TASKUTIL_TASK_DIR"

rm -rf "$TMP_DIR"

