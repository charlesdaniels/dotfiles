#!/usr/bin/fish

function pkg-housecleaning
    pkg-update
    pkg-upgrade
    pkg-dist-upgrade
    pkg-autoremove

end