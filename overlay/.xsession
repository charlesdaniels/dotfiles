# set default language
export LANG=en_US.UTF-8

# export ENV for ksh
export ENV=$HOME/.kshrc

# setup xresources
xrdb -merge $HOME/.Xresources

# set wallpaper
feh --bg-fill $HOME/.wallpapers/wallpaper

# auto lock screen
xidle &

# disable bell
xset b off

# enable pointer scrolling
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5

# load xmodmap settings
xmodmap $HOME/.Xmodmap

# source profile (set PATH)
. $HOME/.profile

# configure display settings
$HOME/bin/configure-display

# run redshift and make sure everything is set up right
$HOME/bin/restore-sanity

# launch cwm
exec cwm
