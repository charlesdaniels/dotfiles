#!/usr/bin/fish

function pkg-dist-upgrade
    pkg-upgrade
    switch (get-pkg-manager)
    case pacaur 
        sudo mkinitcpio -p linux
    case pacman 
        sudo mkinitcpio -p linux
    case apt-get
        sudo apt-get dist-upgrade
    case aptitude 
        echo "not yet implemented"
    case yum 
        echo "not yet implemented"
    case brew
        echo "unsupported operation"
    end
end