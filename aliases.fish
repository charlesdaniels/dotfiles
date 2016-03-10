# this goes in ~/.config/fish/functions/aliases.fish
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
# package managment for debian
#alias agi="sudo apt-get install"
#alias agu="sudo apt-get update"
#alias suu="sudo apt-get update && apt-get upgrade && apt-get dist-upgrade"
#alias acs="apt-cache search" 
#alias agr="sudo apt-get remove"

# utilities 
# alias ddprog="watch -n5 'sudo kill -USR1 `pgrep ^dd`"
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias s="aspell --lang=en_US -t -c" 
alias opendirget="wget -e robots=off -r --level=0 -nc -np --reject html,htm,css"

function extract --description "Expand or extract bundled & compressed files"
  for file in $argv
    if test -f $file
      echo -s "Extracting " (set_color --bold blue) $file (set_color normal)
      switch $file
        case *.tar
          tar -xvf $file
        case *.tar.bz2 *.tbz2
          tar -jxvf $file
        case *.tar.gz *.tgz
          tar -zxvf $file
        case *.bz2
          bunzip2 $file
          # Can also use: bzip2 -d $file
        case *.gz
          gunzip $file
        case *.rar
          unrar x $file
        case *.zip *.ZIP
          unzip $file
        case *.pax
          pax -r < $file
        case '*'
          echo "Extension not recognized, cannot extract $file"
      end
    else
      echo "$file is not a valid file"
    end
  end
end
