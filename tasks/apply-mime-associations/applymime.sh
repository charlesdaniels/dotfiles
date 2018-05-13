#!/bin/sh

printf "INFO: configuring MIME associations"
if [ ! -x "$(which lsdesktopf)" ] ; then
	echo "... FAIL (no lsdesktopf in PATH)"
	exit 1
else
	echo ""
	while read -r line ; do
		mimetype="$(echo "$line" | cut -f 1)"
		desktop="$(echo "$line" | cut -f 2)"
		echo "$line -> use $desktop for $mimetype"
		# make sure the desktop file exists
		if lsdesktopf | grep -i "$desktop" > /dev/null 2>&1 ; then
			xdg-mime default "$desktop" "$mimetype"
		fi
	done < "$TASKUTIL_TASK_DIR/mimeassoc.tsv"
fi
