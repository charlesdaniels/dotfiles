STOW_TARGET=~
STOW_PATH=stow
STOW_CMD=$(STOW_PATH) --target $(STOW_TARGET)

clear-iterm-config:
	# this is a link to a file, which we don't know how to unstow
	-rm ~/com.googlecode.iterm2.plist.bak
	-cp ~/Library/Preferences/com.googlecode.iterm2.plist ~/com.googlecode.iterm2.plist.bak
	-rm ~/Library/Preferences/com.googlecode.iterm2.plist

install:
	cd universal && $(STOW_CMD) bash
	cd universal && $(STOW_CMD) bin
	cd universal && $(STOW_CMD) fish
	cd universal && $(STOW_CMD) tmux
	cd universal && $(STOW_CMD) vim
	cd universal && $(STOW_CMD) todotxt
	cd universal && $(STOW_CMD) profile
	cd universal && $(STOW_CMD) micro
install-osx: install clear-iterm-config
	cd OSX && $(STOW_CMD) subl
	cd OSX && $(STOW_CMD) iterm2
install-unix: install
	cd other-unix && $(STOW_CMD) i3
	cd other-unix && $(STOW_CMD) subl
	cd other-unix && $(STOW_CMD) xdg-user-dirs
	xdg-user-dirs-update

uninstall:
	cd universal && $(STOW_CMD) -D bash
	cd universal && $(STOW_CMD) -D bin
	cd universal && $(STOW_CMD) -D fish
	cd universal && $(STOW_CMD) -D tmux
	cd universal && $(STOW_CMD) -D vim
	cd universal && $(STOW_CMD) -D todotxt
uninstall-osx: uninstall clear-iterm-config
	cd OSX && $(STOW_CMD) -D subl
uninstall-unix:
	cd other-unix && $(STOW_CMD) -D i3

