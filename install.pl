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
use File::Path;
use File::Spec;

my $NOBACKUP = 0;
my $TOOLCHEST = 0;

foreach(@ARGV) {
  if ($_ eq "--nobackup")     { $NOBACKUP  = 1;}
  elsif ($_ eq "--toolchest") { $TOOLCHEST = 1;}
  else {printf "ERROR 53: unrecognized option \"$_\"\n"; die;}
}

if ( ! -e "dotfiles-sigil" ) {
  printf "ERROR 57: installer running outside of dotfiles directory\n";
  die;
}
my @now = localtime();
my $TIMESTAMP = sprintf("%04d%02d%02d%02d%02d%02d",
                        $now[5]+1900, $now[4]+1, $now[3],
                        $now[2],      $now[1],   $now[0]);
my $BACKUP_NAME = "dotfiles_backup-$TIMESTAMP";
my $BACKUP_DIR  = File::Spec->catdir($ENV{HOME}, $BACKUP_NAME);

if ( ! $NOBACKUP ) { mkdir "$BACKUP_DIR"; }

sub backup_file {
  my $target_file = shift;  # relative to home directory
  $target_file = File::Spec->catfile($ENV{HOME}, $target_file);
  if ( $NOBACKUP ) {
    if (-d $target_file) {rmtree $target_file}
    else                 {unlink $target_file}
  } else {
    move $target_file, $BACKUP_DIR;
  }
}

printf "INFO: detecing platform... ";
my $OSTYPE = "POSIX";
my $CURL_OPT = "";  # global curl options
if ( "$^O" =~ "MSWin*" ) { $OSTYPE = "NT"; }
if ( $OSTYPE eq "NT" ) { $CURL_OPT = "$CURL_OPT -k "; }
printf "$^O => $OSTYPE\n";

sub get_cmd_path {
  my $cmd = shift;
  if ($OSTYPE eq "NT") {
    my $cmdpath = `where $cmd`;
    chomp $cmdpath;
    return $cmdpath;
  } else {
    return `which '$cmd' | tr -d '\n'`;
  }
}

sub check_cmd_in_path {
  my $targetCmd = shift;
  printf "INFO: validating  $targetCmd in PATH... ";
  if ( -e get_cmd_path($targetCmd)) {
    printf "OK\n";
  } else {
    printf "FAIL\n";
    die;
  }
}

check_cmd_in_path("git");
check_cmd_in_path("curl");

# vimrc
printf "INFO: installing vimrc... ";
my $VIMRCNAME = ".vimrc";
if ($OSTYPE eq "NT") { $VIMRCNAME = "_vimrc"; }
my $VIMRCPATH = File::Spec->catfile($ENV{HOME}, $VIMRCNAME);
copy(".vimrc", $VIMRCPATH);
printf "DONE\n";

# neovim init.vim
printf "INFO: installing init.vim... ";
my $NVIMRCDIR = File::Spec->catdir($ENV{HOME}, ".config", "nvim");
mkpath($NVIMRCDIR);
my $NVIMRCPATH = File::Spec->catfile($NVIMRCDIR, "init.vim");
copy(".vimrc", $NVIMRCPATH);
printf "DONE\n";

# bashrc
printf "INFO: installing bashrc... ";
backup_file ".bashrc";
backup_file ".bash_profile";
copy "./.bashrc", File::Spec->catfile($ENV{HOME}, ".bashrc");
copy "./.bashrc", File::Spec->catfile($ENV{HOME}, ".bash_profile");
printf "DONE\n";

# tmux.conf
if ($OSTYPE ne "NT") {
  printf "INFO: installing tmux.conf... ";
  backup_file ".tmux.conf";
  copy(".tmux.conf", File::Spec->catfile($ENV{HOME}, ".tmux.conf"));
  if ( -e get_cmd_path("tmux") ) {
    `./mktmux.pl >> ~/.tmux.conf`;
    printf "DONE\n";
  } else {
    printf "WARN\n";
    printf "INFO: tmux is not installed so mouse support was not enabled in ~/.tmux.conf\n";
  }
}

# fish
printf "INFO: installing fish config... ";
backup_file ".config/fish/add-to-path.fish";
backup_file ".config/fish/config.fish";
backup_file ".config/fish/fish-prompt.fish";
my $fishdir = File::Spec->catdir($ENV{HOME}, ".config", "fish");
if ( ! -e $fishdir ) { mkdir $fishdir; }
copy "config.fish", File::Spec->catfile($fishdir, "config.fish");
copy "add-to-path.fish", File::Spec->catfile($fishdir, "add-to-path.fish");
copy "fish-prompt.fish", File::Spec->catfile($fishdir, "fish-prompt.fish");
printf "DONE\n";

# ksh
printf "INFO: installing kshrc... ";
backup_file ".kshrc";
copy ".kshrc", File::Spec->catfile($ENV{HOME}, ".kshrc");
printf "DONE\n";

# ctags
printf "INFO: installing .ctags... ";
backup_file ".ctags";
copy ".ctags", File::Spec->catfile($ENV{HOME}, ".ctags");
printf "DONE\n";

# profile
printf "INFO: installing profile... ";
backup_file ".profile";
copy ".profile", File::Spec->catfile($ENV{HOME}, ".profile");
printf "DONE\n";

# .Xmodmap
printf "INFO: installing .Xmodmap... ";
backup_file ".Xmodmap";
copy ".Xmodmap", File::Spec->catfile($ENV{HOME}, ".Xmodmap");
printf "DONE\n";

# tcsh
printf "INFO: installing tshrc... ";
backup_file ".tcsh";
copy ".tcshrc", File::Spec->catfile($ENV{HOME}, ".tcshrc");
printf "DONE\n";

# todotxt
printf "INFO: installing todo.txt config... ";
backup_file ".todo";
my $tododir = File::Spec->catdir($ENV{HOME}, ".todo");
if ( ! -e $tododir ) { mkdir $tododir; }
copy "todo-config", File::Spec->catfile($tododir, "config");
printf "DONE\n";

# .zsh
printf "INFO: preparing .zsh... ";
backup_file ".zsh";
my $zshdir = File::Spec->catdir($ENV{HOME}, ".zsh");
mkdir($zshdir);
printf "DONE\n";

# zshrc
printf "INFO: installing zshrc... ";
backup_file ".zshrc";
my $zshfile = File::Spec->catfile($ENV{HOME}, ".zshrc");
copy ".zshrc", $zshfile;
printf "DONE\n";

# zsh-autosuggestions
printf "INFO: installing zsh-autosuggestions... ";
my $zshautosuggestions = File::Spec->catdir($zshdir, "zsh-autosuggestions");
`git clone --quiet https://github.com/zsh-users/zsh-autosuggestions $zshautosuggestions`;
printf "DONE\n";

# zsh-fast-syntax-highlighting
printf "INFO: installing zsh-fast-syntax-highlighting... ";
my $zshfastsyntax = File::Spec->catdir($zshdir, "fast-syntax-highlighting");
`git clone --quiet https://github.com/zdharma/fast-syntax-highlighting $zshfastsyntax`;
printf "DONE\n";

# git-completions
printf "INFO: installing git-completion... ";
backup_file ".git-completion.bash";
backup_file ".git-completion.zsh";
my $gitcompletionbase = "https://raw.githubusercontent.com/git/git/master/contrib/completion";
my $gitcompletionbash = File::Spec->catfile($ENV{HOME}, ".git-completion.bash");
my $gitcompletionzsh = File::Spec->catfile($ENV{HOME}, ".zsh", "git-completion.zsh");
`curl $CURL_OPT -LSs $gitcompletionbase/git-completion.bash -o $gitcompletionbash`;
`curl $CURL_OPT -LSs $gitcompletionbase/git-completion.zsh -o $gitcompletionzsh`;
printf "DONE\n";

# i3
if (("$^O" ne "darwin") && ($OSTYPE eq "POSIX")) {
  printf "INFO: installing i3 config... ";
  backup_file ".i3";
  backup_file ".config/i3";
  backup_file ".config/i3status";
  backup_file ".i3status";
  mkdir("$ENV{HOME}/.config");
  mkdir("$ENV{HOME}/.config/i3");
  mkdir("$ENV{HOME}/.config/i3status");
  copy("./i3config", "$ENV{HOME}/.config/i3/config");
  copy("./i3statusconfig", "$ENV{HOME}/.config/i3status/config");
  printf "DONE\n";

}

# .Xresources
printf "INFO: installing .Xresources... ";
if (-e `which xrdb 2>&1 | tr -d '\n'`) {
  backup_file ".Xresources";
  copy("./.Xresources", "$ENV{HOME}/.Xresources");
  `xrdb -merge ~/.Xresources`;
  printf "DONE\n";
} else {
  printf "SKIPPED (no xrdb)\n";
}

# powershell
printf "INFO: installing PowerShell profile... ";
if ($OSTYPE eq "POSIX") {
  backup_file ".config/powershell";
  `mkdir -p ~/.config/powershell`;
  copy("./profile.ps1", "$ENV{HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1");
} else {
  printf "WARN (not supported on NT yet)... ";
}
printf "DONE\n";

# minttyrc
printf "INFO: installing minttyrc... ";
backup_file ".minttyrc";
copy ".minttyrc", File::Spec->catfile($ENV{HOME}, ".minttyrc");
printf "DONE\n";

if ( $TOOLCHEST && ($OSTYPE eq "POSIX") ) {
  printf "INFO: installing net.cdaniels.toolchest... ";
  if ( -e "$ENV{HOME}/.net.cdaniels.toolchest" ) {
    # back up any existing install
    move "$ENV{HOME}/.net.cdaniels.toolchest", "$BACKUP_DIR/.net.cdaniels.toolchest";
  }
  check_cmd_in_path("tar");
  chdir "$ENV{HOME}";
  `git clone https://bitbucket.org/charlesdaniels/toolchest >/dev/null 2>&1`;
  move "$ENV{HOME}/toolchest", "$ENV{HOME}/.net.cdaniels.toolchest";
  chdir "$ENV{HOME}/.net.cdaniels.toolchest";
  `git checkout 1.X.X-STABLE > /dev/null 2>&1`;;
  `git pull origin 1.X.X-STABLE > /dev/null 2>&1`;
  chdir "$ENV{HOME}";
  `$ENV{HOME}/.net.cdaniels.toolchest/bin/toolchest setup`;
  printf "DONE\n";
} elsif ( $TOOLCHEST ) {
  printf "ERROR: net.cdaniels.toolchest does not support platform '$OSTYPE' \n";
}


# backup tarball
if ( ! $NOBACKUP ) {
  if ($OSTYPE eq "NT") {
    printf "ERROR: dotfile backups are not supported on platform '$OSTYPE'\n";
  }
  printf "INFO: generating backups tarball... ";
  chdir "$ENV{HOME}";
  `tar cfz "$BACKUP_NAME.tar.gz" "$BACKUP_NAME"`;
  `rm -rf "$BACKUP_NAME" > /dev/null 2>&1`;
  printf "DONE\n";
  printf "INFO: your previous dotfiles are in: ~/$BACKUP_NAME.tar.gz\n";
}
