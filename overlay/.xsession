# set default language
export LANG=en_US.UTF-8

# export ENV for ksh
export ENV=$HOME/.kshrc

# setup xresources
xrdb -merge $HOME/.Xresources

# set wallpaper
feh --bg-fill $HOME/.wallpapers/wallpaper

# auto lock screen, use mate-settings-daemon on non-OpenBSD systems
if [ "$(uname)" = "OpenBSD" ] ; then
	xidle &
fi

# disable bell
xset b off

# enable pointer scrolling
if [ -e /dev/wsmouse ] ; then
	xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1
	xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2
	xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5
fi

# load xmodmap settings
xmodmap $HOME/.Xmodmap

# source profile (set PATH)
. $HOME/.profile

# configure display settings
$HOME/bin/configure-display

# launch redshift
redshift &

# make sure everything is set up right
$HOME/bin/restore-sanity

# on non-OpenBSD systems, launch mate-settings daemon for volume control
# and screen locking
if [ "$(uname)" != "OpenBSD" ] ; then
	mate-settings-daemon &
	mate-screensaver &
fi

# launch cwm
exec cwm
