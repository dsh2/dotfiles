#!/bin/sh
cd ~/src/SMART/adbcontrol/ 
java -jar adbcontrol.jar &
wmctrl -r "ADB Control" -e 0,0,0,1024,1024
