# My Dotfiles

[![Build Status](https://travis-ci.org/charlesdaniels/dotfiles.svg?branch=master)](https://travis-ci.org/charlesdaniels/dotfiles)

These are my dotfiles. You might have come here looking for my [provisioning
scripts](https://github.com/charlesdaniels/provisioning) or my [utlity
scripts](https://github.com/charlesdaniels/charles-util), both of which were
formerly part of this repository.

This repository now holds only my dotfiles and a few scripts which are so
specific to my setup that I doubt anyone else would find them useful (hence why
they are not in charles-util).

To install, run `./install.sh`. Note that this will **silently overwrite** any
existing dotfiles you may have should they conflict with mine.

This repository works primary via the `overlay` directory, which written
(overlaid) over top of `$HOME`, such that `overlay/something` winds up in
`$HOME/something` after installation. If `$HOME/something` already existed, it
would be silently deleted. There are also a few things cloned from GitHub and
installed via `install.sh`, namely various ZSH extensions.
