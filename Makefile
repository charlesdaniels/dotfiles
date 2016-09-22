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

uninstall:
	cd universal && $(STOW_CMD) -D bash
	cd universal && $(STOW_CMD) -D bin
	cd universal && $(STOW_CMD) -D fish
	cd universal && $(STOW_CMD) -D tmux
	cd universal && $(STOW_CMD) -D vim
uninstall-osx: uninstall
	cd OSX && $(STOW_CMD) -D subl
	cd OSX && $(STOW_CMD) -D iterm2

uninstall-unix:
	cd other-unix && $(STOW_CMD) -D i3
