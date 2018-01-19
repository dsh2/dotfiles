#!/bin/sh
kill $(ps ax | grep  adbcontrol | cut -c 1-5) >& /dev/null
