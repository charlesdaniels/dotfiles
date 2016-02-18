#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '

export PS1="[\u@\h][\A][\w]\n\\$ \[$(tput sgr0)\]"
export TERM=xterm

PATH=$PATH:~/bin
EDITOR=vim
VISUAL=vim

# package managment
alias agi="sudo pacman -S"
alias agu="sudo pacman -Sy"
alias suu="sudo pacman -Syu"
alias acs="pacman -Ss" 
alias agr="sudo pacman -Rs"
alias yagr="yaourt -Rs"
alias yagi="yaourt -S --noconfirm"
alias yagu="yauort -Sy"
alias ysuu="yaourt -Syu"
alias yacs="yaourt -Ss"
# aptitude aliases
#alias agi="sudo apt-get install"
#alias agu="sudo apt-get update"
#alias suu="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove"
#alias agr="sudo apt-get remove"
#alias acs="apt-cache search"

PATH=$PATH:~/bin
EDITOR=vim
VISUAL=vim


# utilities 
alias ddprog="watch -n5 'sudo kill -USR1 `pgrep ^dd`"
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias s="aspell --lang=en_US -t -c" 
alias opendirget="wget -e robots=off -r --level=0 -nc -np --reject html,htm,css"

dirsize () {
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
    egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}


extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xjf $1    ;;
           *.tar.gz)    tar xzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.tar.xz)    tar -xJfv $1   ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xf $1     ;;
           *.tbz2)      tar xjf $1    ;;
           *.tgz)       tar xzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
   echo "'$1' is not a valid file!"
   fi
 }

sysinfo () 
{
	# get system information, then sprunge it 
	touch /tmp/sysinfo
	echo "hostname: $(hostname)" >> /tmp/sysinfo
	echo -e "memory statistics (in megabytes): \n$(free -m)" >> /tmp/sysinfo
	echo -e "filesystem information: \n$(findmnt --df | grep sd)" >> /tmp/sysinfo
	echo -e "VGA card(s): $(lspci | grep -i vga)" >> /tmp/sysinfo
	echo -e "CPU(s): \n$(cat /proc/cpuinfo | grep -i name)" >> /tmp/sysinfo	
	echo -e "kernel version: $(uname -r)" >> /tmp/sysinfo
	cat /tmp/sysinfo | sprunge 
	rm /tmp/sysinfo	
}

PATH="/home/cad/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/cad/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/cad/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/cad/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/cad/perl5"; export PERL_MM_OPT;
