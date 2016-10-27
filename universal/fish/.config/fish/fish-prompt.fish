function fish_prompt
    set EXIT_STATUS $status
    set USER (whoami) > /dev/null 2>&1  # squelches an error on some sysems
    set HOST (hostname)
    set TIME (date +"%H:%M:%S")
    set CWD  (prompt_pwd)
  printf "[$USER@$HOST][$TIME][$CWD]"

    # show exist status of previous command
    if [ $EXIT_STATUS != 0 ]
        set_color red
        printf "[$EXIT_STATUS]"
        set_color normal
    end
    
    printf "\n> "
end
