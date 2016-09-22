STOW_TARGET=~
STOW_PATH=stow
STOW_CMD=$(STOW_PATH) --target $(STOW_TARGET)

install:
	cd universal && $(STOW_CMD) bash
	cd universal && $(STOW_CMD) bin
	cd universal && $(STOW_CMD) fish
	cd universal && $(STOW_CMD) tmux
	cd universal && $(STOW_CMD) vim
install-osx: install
	cd OSX && $(STOW_CMD) subl
	cd OSX && $(STOW_CMD) iterm2
install-unix: install
	cd other-unix && $(STOW_CMD) i3
