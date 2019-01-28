#!/bin/sh

# use wmctrl to bring all windows to the center of the screen

HSIZE=800
VSIZE=600
STAGSTEP=25

res="$(wmctrl -d | grep '[*]' | cut -d ':' -f 2 | cut -d' ' -f 2)"
hres="$(echo "$res" | cut -d'x' -f 1)"
vres="$(echo "$res" | cut -d'x' -f 2)"

cx="$(echo "$hres / 2 - ($HSIZE / 2)" | bc)"
cy="$(echo "$vres / 2 - ($VSIZE / 2)" | bc)"

echo "display detected as $hres x $vres center at $cx,$cy"

wmctrl -l | cut -d' ' -f 5- | while read -r wtitle ; do
	echo "centering window '$wtitle'"
	wmctrl -r "$wtitle" -e "0,$cx,$cy,$HSIZE,$VSIZE"

	# stagger
	cx="$(echo "$cx + $STAGSTEP" | bc)"
	cy="$(echo "$cy + $STAGSTEP" | bc)"
done
