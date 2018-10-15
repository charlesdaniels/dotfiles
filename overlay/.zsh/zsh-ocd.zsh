function ocd () {
	OCD_BLACKLIST_REGEX='(^[/]lib)|(^[/]usr[/]lib)|(^[/]$)|(^[/]var)|(^[/]bin)|(^[/]usr[/]share)|(^[/]usr[/]bin)|(^[/]usr[/]local[/]bin)|(^[/]tmp)|(^[/]dev)|(share[/]fonts)|([/][.]cache[/])|([.]swp$)|(^[/]run)'
	OCD_FILTER_REGEX='(^st)|(^zsh)|(^vim)|(^nvim)|(^pcmanfm)'
	OCD_FILE_LIST=""

	if [ -x "$(which lsof 2>/dev/null)" ] ; then
		OCD_FILE_LIST="$(lsof -u $(whoami) | grep -P $OCD_FILTER_REGEX | awk '{print($9);}' | grep -P '^[/]' | grep -P -v $OCD_BLACKLIST_REGEX | sort | uniq)"
	fi

	# make sure everything in the file list is a directory
	OCD_DIRLIST=""
	for ocd_fpath in $(echo $OCD_FILE_LIST | tr '\n' ' ') ; do
		if [ -f "$ocd_fpath" ] ; then
			ocd_fpath="$(dirname "$ocd_fpath")"
		fi
		OCD_DIRLIST="$ocd_fpath\n$OCD_DIRLIST"
	done

	OCD_TARGET="$(echo "$OCD_DIRLIST" | sort | uniq | grep -v -P '^$' | grep -P "$1")"
	if [ "$(echo "$OCD_TARGET" | wc -l)" -eq 1 ] ; then
		cd "$OCD_TARGET"
	else
		echo "$OCD_TARGET"
	fi

}
