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

printf "INFO: performing preflight check:\n";
printf "\tgit... ";
if ( -e `which git | tr -d '\n'`) {
  printf "OK\n";
} else{
  printf "NOT FOUND\n";
  die;
}
printf "\tcurl... ";
if ( -e `which curl | tr -d '\n'`) {
  printf "OK\n";
} else{
  printf "NOT FOUND\n";
  die;
}
printf "\tgrep... ";
if ( -e `which grep | tr -d '\n'`) {
  printf "OK\n";
} else{
  printf "NOT FOUND\n";
  die;
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

# .vim
printf "INFO: preparing ~/.vim directory... ";
backup_file ".vim";
mkdir("$ENV{HOME}/.vim");
mkdir("$ENV{HOME}/.vim/autoload");
mkdir("$ENV{HOME}/.vim/bundle");
mkdir("$ENV{HOME}/.vim/syntax");
mkdir("$ENV{HOME}/.vim/macros");
mkdir("$ENV{HOME}/.vim/ftplugin");
printf "DONE\n";

# pathogen
printf "INFO: installing pathogen.vim... ";
`curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim > /dev/null 2>&1`;
printf "DONE\n";

# NERDtree
printf "INFO: installing NERDtree... ";
`git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree > /dev/null 2>&1`;
printf "DONE\n";

# netwr
printf "INFO: installing netrw.vba... ";
`curl -L -O http://www.drchip.org/astronaut/vim/vbafiles/netrw.vba.gz > /dev/null 2>&1`;
`gzip -d netrw.vba.gz > /dev/null 2>&1`; 
`vim -c 'so %' -c 'q' netrw.vba > /dev/null 2>&1`; 
unlink("netrw.vba");
printf "DONE\n";

# vim-tex-syntax
printf "INFO: installing vim-tex-syntax... ";
`git clone https://github.com/gi1242/vim-tex-syntax > /dev/null 2>&1`;
move("vim-tex-syntax/syntax/tex.vim", "$ENV{HOME}/.vim/syntax/tex.vim");
rmtree("vim-tex-syntax");
printf "DONE\n";

# octave.vim
printf "INFO: installing octave.vim... ";
`curl -L http://www.vim.org/scripts/download_script.php?src_id=24730 -o octave.vim > /dev/null 2>&1`;
move("octave.vim", "$ENV{HOME}/.vim/syntax/octave.vim");
printf "DONE\n";

# vim-tmux-navigator
printf "INFO: installing vim-tmux-navigator... ";
`git clone https://github.com/christoomey/vim-tmux-navigator.git ~/.vim/bundle/vim-tmux-navigator > /dev/null 2>&1`;
printf "DONE\n";

# vim-pydocstring
printf "INFO: installing vim-pydocstring... ";
`git clone https://github.com/heavenshell/vim-pydocstring > /dev/null 2>&1`;
move("./vim-pydocstring", "$ENV{HOME}/.vim/bundle/vim-pydocstring");
rmtree("./vim-pydocstring"); # sometimes move doesn't clean up the source
printf "DONE\n";

# make sure vim_bridge is available
my $has_vim_bridge = "NO";
`python -c "import vim_bridge" > /dev/null 2>&1`;
if ( $? != 0 ) {
  printf "WARN 167: vim_bridge is not installed, you may want to install it via pip\n";
  printf "INFO: because vim_bridge is not installed, some vim modules will be skipped\n";
  $has_vim_bridge = "NO";
} else {
  $has_vim_bridge = "YES";
}

`vim --version | grep "\-python" > /dev/null 2>&1`;
if ( $? == 0 ) {
  printf "WARN 187: vim_bridge may or may not be available, but your vim binary has been compiled with -python\n";
  printf "INFO: because vim has been compiled with -python, some vim modules will be skipped\n";
  $has_vim_bridge = "NO";
}
printf "INFO: vim_bridge is present and vim has +python... $has_vim_bridge\n";


# vim-rst-tables
printf "INFO: installing vim-rst-tables... ";
if ( $has_vim_bridge eq "YES" ) {
  `git clone https://github.com/nvie/vim-rst-tables.git > /dev/null 2>&1`;
  `cd vim-rst-tables && python build.py > /dev/null 2>&1`;
  move("vim-rst-tables/ftplugin/rst_tables.vim", "$ENV{HOME}/.vim/ftplugin/rst_tables.vim");
  rmtree("./vim-rst-tables");
  `printf "\nsource \"~/.vim/ftplugin/rst_tables.vim\"\n" >> ~/.vimrc`;
  printf "DONE\n";
} else {
  printf "SKIPPED (vim_bridge missing)\n";
}

# vim-ps1
printf "INFO: installing vim-ps1... ";
printf `git clone https://github.com/PProvost/vim-ps1 ~/.vim/bundle/vim-ps1 > /dev/null 2>&1`;
printf "DONE\n";

# tmux.conf
printf "INFO: installing tmux.conf... ";
backup_file ".tmux.conf";
copy("./.tmux.conf", "$ENV{HOME}/.tmux.conf");
if ( -e `which tmux | tr -d '\n'`) {
  `./mktmux.pl >> ~/.tmux.conf`;
  printf "DONE\n";
} else {
  printf "WARN\n";
  printf "INFO: tmux ix not installed so mouse support was not enabled in ~/.tmux.conf\n";
}

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

# .zsh
printf "INFO: preparing .zsh ...";
backup_file ".zsh";
mkdir("$ENV{HOME}/.zsh");
printf "DONE\n";

# zshrc 
printf "INFO: installing zshrc... ";
backup_file ".zshrc";
copy "./.zshrc", "$ENV{HOME}/.zshrc";
printf "DONE\n";

# zsh-autosuggestions
printf "INFO: installing zsh-autosuggestions... ";
`git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions > /dev/null 2>&1`;
printf "DONE\n";

# zsh-syntax-highlighting
#printf "INFO: installing 155-6102ax-highlighting... ";
#` git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting > /dev/null 2>&1`;
#printf "DONE\n";

# zsh-fast-syntax-highlighting
printf "INFO: installing zsh-fast-syntax-highlighting... ";
`git clone https://github.com/zdharma/fast-syntax-highlighting ~/.zsh/fast-syntax-highlighting > /dev/null 2>&1`;
printf "DONE\n";

# git-completions
printf "INFO: installing git-completion... ";
backup_file ".git-completion.bash";
backup_file ".git-completion.zsh";
`curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash > /dev/null 2>&1`;
`curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash > /dev/null 2>&1`;
`curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.zsh/git-completion.zsh > /dev/null 2>&1`;
copy("$ENV{HOME}/.git-completion.zsh", "$ENV{HOME}/.zsh/_git");
printf "DONE\n";


# i3
if ("$^O" ne "darwin") {
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

  # .Xresources
  printf "INFO: installing .Xresources... ";
  if (-e `which xrdb 2>&1 | tr '\n' ' '`) {
    backup_file ".Xresources";
    copy("./.Xresources", "$ENV{HOME}/.Xresources");
    `xrdb -merge ~/.Xresources`; 
    printf "DONE\n";
  } else {
    printf "SKIPPED (no xrdb)\n";
  }
}


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








