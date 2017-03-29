#!/usr/bin/env perl
########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#  
#  Installs my dotfiles, preserving a backup of any existing dotfiles. 
#
#  USAGE
#  =====
# 
#  --nobackup . . . delete any existing dotfiles without backing up
#
#  --toolchest  . . also install net.cdaniels.toolchest (requires git)
#
########10########20########30##### LICENSE ####50########60########70########80
# Copyright (c) 2017, Charles Daniels
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, 
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation 
# and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its 
# contributors may be used to endorse or promote products derived from this 
# software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
########10########20########30########40########50########60########70########80

use strict;
use warnings;
use File::Copy;

my $NOBACKUP = 0;
my $TOOLCHEST = 0;

foreach(@ARGV) {
  if ($_ eq "--nobackup")     { $NOBACKUP  = 1;}
  elsif ($_ eq "--toolchest") { $TOOLCHEST = 1;}
  else {printf "ERROR 53: unrecognized option \"$_\"\n"; die;}
}

if ( ! -e "./dotfiles-sigil" ) {
  printf "ERROR 57: installer running outside of dotfiles directory\n";
  die;
}
my @now = localtime();
my $TIMESTAMP = sprintf("%04d%02d%02d%02d%02d%02d", 
                        $now[5]+1900, $now[4]+1, $now[3],
                        $now[2],      $now[1],   $now[0]);
my $BACKUP_NAME = "dotfiles_backup-$TIMESTAMP";
my $BACKUP_DIR  = "$ENV{HOME}/$BACKUP_NAME";

if ( ! $NOBACKUP ) { mkdir "$BACKUP_DIR"; }

sub backup_file {
  my $target_file = shift;  # relative to home directory
  if ( $NOBACKUP ) {
  	unlink "$ENV{HOME}/$target_file"; 
  } else {
  	move "$ENV{HOME}/$target_file", "$BACKUP_DIR";
  }
}

# bashrc
printf "INFO: installing bashrc... ";
backup_file ".bashrc";
backup_file ".bash_profile";
copy "./.bashrc", "$ENV{HOME}/.bashrc";
copy "./.bashrc", "$ENV{HOME}/.bash_profile";
printf "DONE\n";

# vimrc
printf "INFO: installing vimrc... ";
backup_file ".vimrc";
copy "./.vimrc", "$ENV{HOME}/.vimrc";
printf "DONE\n";

# tmux.conf
printf "INFO: installing tmux.conf... ";
backup_file ".tmux.conf";
copy "./.tmux.conf", "$ENV{HOME}/.tmux.conf";
printf "DONE\n";

# fish
printf "INFO: installing fish config... ";
backup_file ".config/fish/add-to-path.fish";
backup_file ".config/fish/config.fish";
backup_file ".config/fish/fish-prompt.fish";
if ( ! -e "$ENV{HOME}/.config/fish" ) { mkdir "$ENV{HOME}/.config/fish"; }
copy "./config.fish", "$ENV{HOME}/.config/fish/config.fish";
copy "./add-to-path.fish", "$ENV{HOME}/.config/fish/add-to-path.fish";
copy "./fish-prompt.fish", "$ENV{HOME}/.config/fish/fish-prompt.fish";
printf "DONE\n";

# ksh
printf "INFO: installing kshrc... ";
backup_file ".kshrc";
copy "./.kshrc", "$ENV{HOME}/.kshrc";
printf "DONE\n";

# profile
printf "INFO: installing profile... ";
backup_file ".profile",
copy "./.profile", "$ENV{HOME}/.profile";
printf "DONE\n";

# tcsh
printf "INFO: installing tshrc... ";
backup_file ".tcsh";
copy "./.tcshrc", "$ENV{HOME}/.tcshrc";
printf "DONE\n";

# todotxt
printf "INFO: installing todo.txt config... ";
backup_file ".todo/config";
if ( ! -e "$ENV{HOME}/.todo" ) { mkdir "$ENV{HOME}/.todo"; }
copy "./todo-config", "$ENV{HOME}/.todo/config";
printf "DONE\n";

# zsh 
printf "INFO: installing zshrc... ";
backup_file ".zshrc";
copy "./.zshrc", "$ENV{HOME}/.zshrc";
printf "DONE\n";

if ( $TOOLCHEST ) {
  printf "INFO: installing net.cdaniels.toolchest... ";
  my $GIT_PATH = `which git`;
  chomp $GIT_PATH;
  if ( ! -e "$GIT_PATH" ) {
    printf "FAIL\n";
    printf "ERROR 159: git is not installed\n";
    die;
  }
  if ( -e "$ENV{HOME}/.net.cdaniels.toolchest" ) { 
    # back up any existing install
    move "$ENV{HOME}/.net.cdaniels.toolchest", "$BACKUP_DIR/.net.cdaniels.toolchest";
  }
  chdir "$ENV{HOME}";
  `git clone https://bitbucket.org/charlesdaniels/toolchest >/dev/null 2>&1`;
  move "$ENV{HOME}/toolchest", "$ENV{HOME}/.net.cdaniels.toolchest";
  chdir "$ENV{HOME}/.net.cdaniels.toolchest";
  `git checkout 1.X.X-STABLE > /dev/null 2>&1`;;
  `git pull origin 1.X.X-STABLE > /dev/null 2>&1`;
  chdir "$ENV{HOME}";
  `$ENV{HOME}/.net.cdaniels.toolchest/bin/toolchest setup`;
  printf "DONE\n";

}


# backup tarball
if ( ! $NOBACKUP ) {
  printf "INFO: generating backups tarball... ";
  chdir "$ENV{HOME}";
  `tar cfz "$BACKUP_NAME.tar.gz" "$BACKUP_NAME"`;
  `rm -rf "$BACKUP_NAME" > /dev/null 2>&1`;
  printf "DONE\n";
  printf "INFO: your previous dotfiles are in: ~/$BACKUP_NAME.tar.gz\n";
}








