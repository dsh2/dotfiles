#!/bin/zsh

: ${remote_host:=1.1.1.1}
: ${reboot_delay_seconds:=30}

while :; do 
	ping -W1 -c3 $remote_host || {
		wall "Offline situation detected. Failed to ping $remote_host. About to reboot in $reboot_delay_seconds seconds. Kill pid $$ to prevent this."
		sleep $reboot_delay_seconds
		reboot
	}
	sleep 5
done
