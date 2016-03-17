#!/usr/bin/fish

# get the name of the most prioritized package manager installed on the system

function get-pkg-manager
    command --search pacaur >/dev/null; and begin
        echo "pacaur"
        return 0
    end;

    command --search pacman >/dev/null; and begin
        echo "pacman"
        return 0
    end;

    command --search apt-get >/dev/null; and begin
        echo "apt-get"
        return 0
    end;

    command --search aptitude >/dev/null; and begin
        echo "aptitude"
        return 0
    end;

    command --search yum >/dev/null; and begin
        echo "yum"
        return 0
    end;

    command --search brew >/dev/null; and begin
        echo "brew"
        return 0
    end;

    echo "no known package manager found"
    return 100
end