#!/usr/bin/fish

function pkg-upgrade
    switch (get-pkg-manager)
    case pacaur 
        pacaur -Syu
    case pacman 
        sudo pacman -Syu
    case apt-get
        sudo apt-get upgrade
    case aptitude 
        sudo aptitude upgrade
    case yum 
        sudo yum upgrade
    case brew
        echo "unsupported operation"
    end
end