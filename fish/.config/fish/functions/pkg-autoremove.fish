#!/usr/bin/fish

function pkg-autoremove
    pkg-upgrade
    switch (get-pkg-manager)
    case pacaur 
        echo "unsupported operation"
    case pacman 
        echo "unsupported operation"
    case apt-get
        sudo apt-get autoremove
    case aptitude 
        echo "not yet implemented"
    case yum 
        echo "not yet implemented"
    case brew
        echo "unsupported operation"
    end
end