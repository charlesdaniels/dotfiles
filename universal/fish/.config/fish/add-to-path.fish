function add-to-path
    if test -d "$argv"
        set -gx PATH $argv $PATH
    end
end