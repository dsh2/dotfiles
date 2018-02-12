#!/bin/sh
#wmctrl -ai $(wmctrl -lp | grep $(pidof xfce4-terminal) | cut -d ' ' -f 1)
wmctrl -a chrome
