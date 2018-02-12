#!/bin/sh
#wmctrl -ai $(wmctrl -lp | grep $(pidof xfce4-terminal) | cut -d ' ' -f 1)
wmctrl -ia $(wmctrl -l -p | grep $(pgrep -f -i com.intellij.idea.Main) | cut -c -10)
