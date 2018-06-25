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
