#!/bin/bash
i3-msg 'workspace ✉'
i3-msg 'exec thunderbird'
sleep 3
i3-msg 'workspace ♫'
i3-msg 'exec spotify-hidpi' 
sleep 2
i3-msg 'workspace 1'
