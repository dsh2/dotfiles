#!/bin/zsh

set -e
local -r n=/dev/null

ssh_notify() 
{
	level=$1; shift # low, normal, critical
	msg="$*"
	# TODO: Map level to systemd prio
	logger -it ssh -- "$R: $msg"
	# TODO: Update to notify-send.py
	# TODO: Add icon
	notify-send -u $level -a "ssh $R" "$msg"
}

check_remote_clock() 
{
	time_diff_ok=2 # seconds
	time_diff=$[ $(ssh $R date -u '+%s') - $(date -u '+%s') ]
	(( $time_diff > $time_diff_ok ||  $time_diff < -$time_diff_ok )) &&
		ssh_notify critical "Remote clock deviates more than $time_diff_ok seconds (diff = $time_diff)."
}

mount_remote_fs() 
{
	local sshfs_opts="-C -o idmap=user -o transform_symlinks" 
	local mnt_point=$local_home/mnt/$remote_hostname_cmd
	mkdir -p $mnt_point || { ssh_notify critical "Failed to create mount point \"$mnt_point\"." ; return ; }
	sshfs -C $R:/ $mnt_point || { ssh_notify critical "sshfs failed." ; return ; }
	ssh_notify low "Successfully mounted sshfs."

	# Create second mount point with root access - if possible
	[[ $( ssh $R sudo id -u ) = 0 ]] || return 
	mnt_point=$mnt_point-ROOT
	mkdir -p $mnt_point || { ssh_notify critical "Failed to create mount point \"$mnt_point\"." ; return ; }

	local ssh_cmd="ssh -J $R"
	ssh_cmd+=" -i $local_home/.ssh/hosts/$remote_hostname_cmd/id"
	ssh_cmd+=" -o HostKeyAlias=ROOT-$R"
	ssh_cmd+=" -o StrictHostKeyChecking=accept-new"

	sshfs -o ssh_command=$ssh_cmd root@localhost:/ $mnt_point || 
		{ ssh_notify critical "sshfs failed for root." ; return ; }
	
	ssh_notify low "Successfully mounted sshfs as root."
}

connect_tun() 
{
	[[ $local_tuntap = tun* ]] || return
	local -r tun=$local_tuntap
	local -r nw=${tun#tun}
	local -r l_ip=10.0.$nw.1
	local -r r_ip=10.0.$nw.2
	ssh_notify normal "Hello! $l_ip $r_ip"
	
	# Check if remote tun is availble
	if ! ssh $R test -e /sys/class/net/$tun; then
		if ssh $R sudo sh <<< "
			ip tuntap add dev $tun mode tun user $remote_username && 
			ip address add $r_ip/24 dev $tun &&
			ip link set dev $tun up";
		then
			 ssh_notify critical "Successfully created remote tun \"$tun\". Please restart ssh." 
		else
			 ssh_notify critical "Failed to create remote tun \"$tun\"" 
		fi
		return
	fi
	
	&>$n ping -W 1 -c 2 -i 0.2 $r_ip         || { ssh_notify critical "Outbound ping failed."; return ; }
	&>$n ssh $R ping -W 1 -c 2 -i 0.2 $l_ip  || { ssh_notify critical "Inbound ping failed."; return ; }
	
	# TODO: Sysctl forward for tun, e.a.
	ssh_notify low "Successfully connected tunnel."
}

main() 
{
	
	(( $#@ >= 11 )) ||  return 
	C_hash=$1
	local_home=$2
	remote_hostname=$3
	local_user_id=$4
	local_hostname=$5
	local_hostname_full=$6
	remote_hostname_cmd=$7
	remote_port=$8
	remote_username=$9; shift
	local_tuntap=$9; shift
	local_username=$9
	# TODO: Check if adding '-p $remote_port' makes sense...
	R="$remote_username@$remote_hostname"
	( umask 077; echo $R > /tmp/ssh )

	sleep 0.1
	ssh -qO check $R || { ssh_notify critical "Connection failed to multiplex." ; return 1 ; }
	# check_remote_clock
	# mount_remote_fs
	connect_tun
}

main $@
