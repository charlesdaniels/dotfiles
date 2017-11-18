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

set -u

printf "INFO: detecting system information"

# make sure we have access to the realpath command
if [ ! -x "$(which realpath)" ] ; then
	if [ ! -e "./lib/realpath.lib" ] ; then
		echo "PANIC: no 'realpath', and failed to load ./lib/realpath.lib"
		exit 1
	fi
	. ./lib/realpath.lib
fi
printf "."

PARENT_DIR="$(realpath "$(dirname "$0")")"
printf "."
PROVISION_DIR=$(realpath "$PARENT_DIR/provision")
printf "."
OVERLAY_DIR=$(realpath "$PROVISION_DIR/overlay")
printf "."
THIRDPARTY_DIR="$(realpath "$PARENT_DIR/3rdparty")"
printf "."
PLATFORM=$(uname)
printf "."
echo " DONE"
echo "INFO: PARENT_DIR . . . . . $PARENT_DIR"
echo "INFO: PROVISION_DIR  . . . $PROVISION_DIR"
echo "INFO: OVERLAY_DIR  . . . . $OVERLAY_DIR"
echo "INFO: THIRDPARTY_DIR . . . $THIRDPARTY_DIR"
echo "INFO: PLATFORM . . . . . . $PLATFORM"

# run bootstrapping script
if [ -e "$PROVISION_DIR/platform/$PLATFORM/bootstrap.include" ] ; then
	. "$PROVISION_DIR/platform/$PLATFORM/bootstrap.include"
else
	echo "INFO: no user bootstrapping script for platform '$PLATFORM'"
fi

# perform sanity check for binaries we need
printf "INFO: performing sanity check"
for bin in uuidgen curl git ln; do
	if [ ! -x "$(which "$bin")" ] ; then
		echo " FAIL"
		echo "PANIC: missing dependency: $bin"
		exit 1
	fi
	printf "."
done
if [ ! -d "$HOME" ] ; then
	echo " FAIL"
	echo "PANIC: home directory '$HOME' does not exist"
	exit 1
fi
printf "."
echo " DONE"

# make sure all of our submodules are cloned and up to date
printf "INFO: updating submodules... "
if ! git submodule update --rebase --remote --quiet ; then
	echo "FAIL"
	echo "PANIC: failed to update submodules"
fi
echo "DONE"

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


########10########20########30##### cleanup ####50########60########70########80

# remove temp directory
printf "INFO: cleaning up temp directory... "
rm -rf "$TMP_DIR"
echo "DONE"
