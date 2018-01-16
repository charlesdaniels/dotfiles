#/bin/sh

# WARNING: this script deletes things without asking; please read it!
#
# This script is used to perform an OS-level provision, and requires root
# access.

########10########20########30###### setup #####50########60########70########80

if [ ! -e "lib/setup.lib" ] ; then
	echo "PANIC: could not find setup.lib, did you run this script from it's parent directory?"
	exit 1
fi

. "lib/setup.lib"

# authenticate with sudo
echo "INFO: authenticating with sudo, you may will be prompted for your password."
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

########10########20########30 platform specific 0########60########70########80

if [ -e "$PLATFORM_DIR/provision-system.include" ] ; then
	. "$PLATFORM_DIR/provision-system.include"
else
	echo "INFO: no system-specific provisioning file for platform '$PLATFORM'"
fi

if [ -e "$VARIANT_DIR/provision-system.include" ] ; then
	. "$VARIANT_DIR/provision-system.include"
else
	echo "INFO: no variant-specific provision file for platform '$PLATFORM/$VARIANT'"
fi

########10########20######## platform independent ########60########70########80

# Turn on pwfeedback for sudo
sudo sh -c 'if ! cat /etc/sudoers | grep pwfeedback > /dev/null ; then echo "Defaults	pwfeedback" >> /etc/sudoers ; fi'

# install R packages
printf "INFO: installing R packages"
if [ -e "$(which R)" ] ; then
	printf "."
	for f in "$PROVISION_DIR/R"/*.R ; do
		if ! sudo R --no-save < "$f" > "$LOG_DIR/$(basename "$f").log" 2>&1 ; then
			echo " FAIL"
			echo "PANIC: failed to execute R script '$f', see '$LOG_DIR/$(basename "$f").log'"
			exit 1
		fi
		printf "."
	done
	echo " DONE"
else
	echo "... SKIP (R not installed)"
fi

# install Python packages
printf "INFO: installing Python 2 packages"
if [ -e "$(which pip)" ] ; then
	while read -r line ; do
		run_step "$LOG_DIR/pip2.log" sudo pip install "$line"
	done < "$PROVISION_DIR/python2.list"
else
	echo "... SKIP (pip not installed)"
fi
echo ". DONE"

printf "INFO: installing Python 3 packages"
if [ -e "$(which pip3)" ] ; then
	while read -r line ; do
		run_step "$LOG_DIR/pip3.log" sudo pip3 install "$line"
	done < "$PROVISION_DIR/python3.list"
else
	echo "... SKIP (pip3 not installed)"
fi
echo ". DONE"
