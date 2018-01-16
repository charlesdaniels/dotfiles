#/bin/sh

# WARNING: this script deletes things without asking; please read it!

# This script provisions my environment. In particular, this script only
# performs unprivileged operations that act on my home directory. This script
# is suitable for use on systems where root access is not available.
#
# Note that this script may arbitrarily overwrite configuration files
# (overlay), items in ~/bin, and so on without warning. If anyone other than
# me ever uses this, I expect you to read it first - in full.

########10########20########30###### setup #####50########60########70########80

if [ ! -e "lib/setup.lib" ] ; then
	echo "PANIC: could not find setup.lib, did you run this script from it's parent directory?"
	exit 1
fi

. "lib/setup.lib"

# setup temp directory
printf "INFO: setting up temp directory"
TMP_DIR="/tmp/$(uuidgen)"
printf "."
mkdir -p "$TMP_DIR"
printf "."
if [ ! -e "$TMP_DIR" ] ; then
	echo " FAIL"
	echo "PANIC: could not create temp directory '$TMP_DIR'"
	exit 1
fi
printf "."
if [ "$(realpath "$TMP_DIR")" = "$(realpath /tmp)" ] ; then
	echo " FAIL"
	echo "PANIC: uuidgen failed"
	exit 1
fi
echo " DONE"

########10########20########30#### overlay #####50########60########70########80

# generate manifest of overlay files to link into ~
printf "INFO: generating overlay manifest"
START_DIR="$(pwd)"
OVERLAY_MANIFEST="$TMP_DIR/overlay.manifest"
cd "$OVERLAY_DIR"
find . -type f -print | while read f do ; do
	echo "$f" >> "$OVERLAY_MANIFEST"
	printf "."
done
echo " DONE"
echo "INFO: found $(wc -l < "$OVERLAY_MANIFEST" | tr -d ' ') files to install"
cd "$START_DIR"

# purge any files mentioned in the manifest
printf "INFO: deleting overlay files from $HOME"
while read -r f ; do
	FULLPATH="$HOME/$f"
	if [ -f "$FULLPATH" ] ; then
		# delete the file only if it exists
		rm "$FULLPATH"
	fi
	if [ -L "$FULLPATH" ] ; then
		# delete the file only if it exists (account for symlinks)
		rm "$FULLPATH"
	fi
	printf "."
done < "$OVERLAY_MANIFEST"
echo " DONE"

# link overlay into the right places
printf "INFO: linking overlay files"
while read -r f ; do
	DESTPATH="$HOME/$f"
	DESTDIR="$(dirname "$DESTPATH")"
	SRCPATH="$(realpath "$OVERLAY_DIR/$f")"

	if [ ! -f "$SRCPATH" ] ; then
		echo " FAIL"
		echo "PANIC: '$SRCPATH' does not exist"
		exit 1
	fi

	# make sure the parent dir of the destination file exists
	if [ -L "$DESTDIR" ] ; then
		rm "$DESTDIR"
	fi

	if [ ! -d "$DESTDIR" ] ; then
		mkdir -p "$DESTDIR"
	fi

	if [ ! -d "$DESTDIR" ] ; then
		echo " FAIL"
		echo "PANIC: '$DESTDIR' does not exist, and it could not be created"
		exit 1
	fi

	if ! ln -s "$SRCPATH" "$DESTPATH" > /dev/null 2>&1 ; then
		echo " FAIL"
		echo "PANIC: failed to link '$SRCPATH' to '$DESTPATH'"
		exit 1
	fi

	printf "."
done < "$OVERLAY_MANIFEST"
echo " DONE"


########10########20### third-party script installation ##60########70########80

for f in "$THIRDPARTY_DIR"/*.include ; do
	. "$f"
done

########10########20### platform-specific configuration ##60########70########80

if [ -e "$PROVISION_DIR/platform/$PLATFORM/provision-user.include" ] ; then
	. "$PROVISION_DIR/platform/$PLATFORM/provision-user.include"
else
	echo "INFO: no platform-specific configuration for '$PLATFORM'"
fi

if [ -e "$VARIANT_DIR/provision-user.include" ] ; then
	. "$VARIANT_DIR/provision-user.include"
else
	echo "INFO: no variant-specific provision file for platform '$PLATFORM/$VARIANT'"
fi


########10########20######## platform independent ########60########70########80

printf "INFO: applying .Xresources.."
if [ -x "$(which xrdb)" ] ; then
	if [ "$PLATFORM" = "Darwin" ] ; then
		echo ". SKIP (disabled on $PLATFORM)"
	else
		run_step "$LOG_DIR/xrdb.log" xrdb -merge ~/.Xresources
		echo " DONE"
	fi
fi

########10########20########30##### cleanup ####50########60########70########80

# remove temp directory
printf "INFO: cleaning up temp directory... "
rm -rf "$TMP_DIR"
echo "DONE"
