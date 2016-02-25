#!/bin/bash
sleep 2
i3-msg 'workspace ✉'
i3-msg 'exec thunderbird'
sleep 10
i3-msg 'workspace ♫'
i3-msg 'exec spotify-hidpi' 
sleep 5
i3-msg 'workspace ⇵'
i3-msg 'exec firefox'
sleep 5
i3-msg 'workspace 1'

