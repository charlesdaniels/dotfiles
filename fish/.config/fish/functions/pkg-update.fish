#!/usr/bin/fish

function pkg-update
    switch (get-pkg-manager)
    case pacaur 
        pacaur -Syy
    case pacman 
        sudo pacman -Syy
    case apt-get
        sudo apt-get update
    case aptitude 
        sudo aptitude update
    case yum 
        sudo yum update
    case brew
        brew update
    end
end