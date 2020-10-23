#!/bin/sh

C_hash=$1
local_home=$2
remote_hostname=$3
local_user_id=$4
local_hostname=$5
local_hostname_full=$6
remote_hostname_cmd=$7
remote_port=$8
remote_username=$9
local_tuntap=$10
local_username=$11

ssh_notify() {
	msg="$*"
	logger -it ssh -- $msg
	notify-send -u critical -a ssh -c ssh "$msg"
}

# notify-send -a ssh -c ssh "LocalCommand $* ($#)"

sleep 1.1
if ! ssh -qO check $remote_username@$remote_hostname_cmd; then
	ssh_notify "[$local_username@$local_hostname] Connection for $remote_username@$remote_hostname_cmd failed to multiplex."
	exit 1
fi

# Check remote host clock
time_diff_ok=5
time_diff=$[ $(ssh $remote_username@$remote_hostname_cmd date -u '+%s') - $(date -u '+%s')]

if [ $time_diff -gt $time_diff_ok -o $time_diff -lt -$time_diff_ok ]; then
	ssh_notify "Remote host time for $remote_username@$remote_hostname_cmd deviates more than $time_diff_ok seconds."
fi

# Mount remote host filesystems
mkdir -p $local_home/mnt/$remote_hostname_cmd
if sshfs -p $remote_port $remote_username@$remote_hostname_cmd:/ $local_home/mnt/$remote_hostname_cmd ; then
	# ssh_notify "Mounted sshfs for $remote_username@$remote_hostname_cmd to ~/mnt/$remote_hostname_cmd."
	:
else
	ssh_notify "Failed to mount sshfs for $remote_username@$remote_hostname_cmd to ~/mnt/$remote_hostname_cmd."
fi

exit 0
