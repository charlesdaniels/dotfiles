#!/bin/bash
i3-msg 'workspace ✉'
i3-msg 'exec surf https://fastmail.com'
sleep 3
i3-msg 'workspace ♫'
i3-msg 'exec spotify-hidpi' 
sleep 3
i3-msg 'workspace ⇵'
i3-msg 'exec firefox'
sleep 3
i3-msg 'workspace 1'

