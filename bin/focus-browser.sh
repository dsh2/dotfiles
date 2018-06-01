#!/bin/sh
#wmctrl -ai $(wmctrl -lp | grep $(pidof xfce4-terminal) | cut -d ' ' -f 1)
# wmctrl -ai $(wmctrl -l | \grep -i chrome | head -1 | cut -d\  -f 1)
herbstclient jumpto $(wmctrl -l | \grep -i chrome | head -1 | cut -d\  -f 1)
