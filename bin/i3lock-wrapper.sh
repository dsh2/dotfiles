#!/bin/sh
# TODO: Add mute, rfkill, standard workspace, etc.?
revert() {
  xset dpms 0 0 0
}
trap revert HUP INT TERM
xset +dpms dpms 5 5 5
i3lock -n -c ff0000 -f -e
revert
