#!/bin/sh

# .SCRIPTDOC

# This script can be downloaded using `wget` or similar. It will download a
# statically linked git executable and then use this to clone the entire 
# dotfiles repo, after which it will automatically run `provision-user.sh`.
# After that point, even if the system does not have git available, the 
# Linux platform bootstraping script will permanently install a git binary
# into ~/bin, which will be sufficient to run provision-system.sh.

# Note that this requires an i686 or x86_64 CPU.

# Be warned, this script is often used on machine swhich are sufficently out
# of date that SSL certificates cannot be validated reliabily. To that end,
# it downloads and executes various pieces of code and runs them without
# validating SSL certificates.

# .ENDOC
#

# .DOCUMENTS download_file

# Attempt to download a file in a portable way using curl or wget, according to
# which is available.

# This was copied here from it's original in lib/download.lib, for
# convenience.

# .SYNTAX
#
# $1 . . . URL to download
# $2 . . . destination file

# .AUTHOR
#
# Charles Daniels

# .LICENSE

# Copyright 2018 Charles Daniels

#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:

#  1. Redistributions of source code must retain the above copyright notice,
#  this list of conditions and the following disclaimer.

#  2. Redistributions in binary form must reproduce the above copyright notice,
#  this list of conditions and the following disclaimer in the documentation
#  and/or other materials provided with the distribution.

#  3. Neither the name of the copyright holder nor the names of its
#  contributors may be used to endorse or promote products derived from this
#  software without specific prior written permission.

#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.

# .ENDOC

download_file () {

	if [ -x "$(which curl)" ] ; then
		curl -LSso "$2" "$1" > /dev/null 2>&1
		return $?
	elif [ -x "$(which wget)" ] ; then
		wget --quiet --no-check-certificate "$1" -O "$2" > /dev/null 2>&1
		return $?
	else
		return 1
	fi

}

STATIC_GET_URL='https://raw.githubusercontent.com/minos-org/minos-static/master/static-get'
DOTFILES_URL="git://github.com/charlesdaniels/dotfiles.git"
TEMP_DIR="/tmp/$(uuidgen)"
mkdir -p "$TEMP_DIR/bin"

OLDPATH="$PATH"
PATH="$TEMP_DIR/bin:$PATH"
PATH="$TEMP_DIR/usr/bin:$PATH"

printf "INFO: fetching git binary"
if ! download_file "$STATIC_GET_URL" "$TEMP_DIR/bin/static-get" ; then
	echo "... FAIL"
	echo "ERROR: faild to download static-get"
	exit 1
else
	chmod +x "$TEMP_DIR/bin/static-get"
	printf "."
fi

if ! static-get --download "$TEMP_DIR" git-2 > /dev/null 2>&1 ; then
	echo " FAIL"
	echo "ERROR: failed to fetch git"
	exit 1
else
	printf "."
	cd "$TEMP_DIR"
	for f in *.tar* ; do
		tar xf "$f"
	done
	printf "."
fi

if [ ! -x "$(which git)" ] ; then
	echo " FAIL"
	echo "ERROR: failed to install git"
	exit 1
else
	printf "."
fi

echo " DONE"

cd "$HOME"
git clone "$DOTFILES_URL"
cd "$HOME/dotfiles"
export PATH="$OLDPATH"
sh ./provision-user.sh

rm -rf "$TEMP_DIR"
