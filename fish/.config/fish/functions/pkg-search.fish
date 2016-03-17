#!/usr/bin/fish

function pkg-search
    switch (get-pkg-manager)
    case pacaur 
        pacaur -Ss $argv
    case pacman 
        pacman -Ss $argv
    case apt-get
        apt-cache search $argv
    case aptitude 
        aptitude search $argv
    case yum 
        yum search $argv
    case brew
        brew search $argv
    end
end