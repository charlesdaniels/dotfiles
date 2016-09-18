install:
	cd universal && stow bash
	cd universal && stow bin
	cd universal && stow fish
	cd universal && stow tmux
	cd universal && stow vim
	ifeq ($(UNAME_S),Darwin):
		cd OSX && stow subl
	else
		cd other-unix && stow i3
	endif