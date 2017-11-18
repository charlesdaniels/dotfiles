#!/usr/bin/env perl
########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#
#  Generates a ~/.tmux.conf file according to the install tmux version. This is
#  required because different tmux versions require different options to
#  configure mouse support. Note that a .tnux.conf must be present in ./ which
#  is used as a base - this script only generates the mouse-related
#  configuration options, which are emitted on stdout. 
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

if ( ! -e "./dotfiles-sigil" ) {
  printf "ERROR 45: mktmux will not run outside of dotfiles directory!\n";
  die;
}

if ( ! -e "./.tmux.conf" ) {
  printf "ERROR 50: a base .tmux.conf file is required!\n";
  die;
}

my $tmuxvers = `tmux -V | cut -d\\  -f 2 | tr -d '.' | tr -d '\n'`;
my $currentdate = `date`;

printf "\n# tmux configuration auto-generated during dotfile install\n";
printf "# generated on: $currentdate\n";
printf "# detected tmux version: $tmuxvers\n\n";

# mouse configuration
if ($tmuxvers ge 21) {
  printf "# mouse configuration selected because version >= 21\n";
  printf "set -g mouse on\n";
}

if ($tmuxvers lt 21) {
  printf "# mouse configuration selected because version < 21\n";
  printf "set -g mouse on\n";
  printf "set -g mouse-select-window on\n";
  printf "set -g mouse-select-pane on\n";
  printf "set -g mouse-resize-pane on\n";
  printf "setw -g mouse\n";
}

# tmux-navigator 
if ($tmuxvers ge 1.8) {
  printf "# vim-tmux-navigator configuration selected because version >= 18\n";
  printf "is_vim=\"ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\\\\S+\\\\\/)?g?(view|n?vim?x?)(diff)?\$'\"\n";
  printf "bind-key -n C-h if-shell \"\$is_vim\" \"send-keys C-h\"  \"select-pane -L\"\n";
  printf "bind-key -n C-j if-shell \"\$is_vim\" \"send-keys C-j\"  \"select-pane -D\"\n";
  printf "bind-key -n C-k if-shell \"\$is_vim\" \"send-keys C-k\"  \"select-pane -U\"\n";
  printf "bind-key -n C-l if-shell \"\$is_vim\" \"send-keys C-l\"  \"select-pane -R\"\n";
  printf "bind-key -n C-\\ if-shell \"\$is_vim\" \"send-keys C-\\\\\" \"select-pane -l\"\n";
}


