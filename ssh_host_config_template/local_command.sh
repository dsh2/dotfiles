#!/bin/zsh

# TODO: Set alarm to detect run-anway scripts
 
local -r n=/dev/null

ssh_notify() 
{
	local -r level=${SSH_DEBUG:-$1}; shift # low, normal, critical
	local -r msg="$*"
	local app="ssh $R"
	[ -z $SSH_GROUP ] || app="$app ($SSH_GROUP)"
	
	# TODO: Map level to systemd prio
	logger -it ssh -- "$app: $msg"
	
	# TODO: Update to notify-send.py
	# TODO: Add icon
	notify-send -u $level -a $app -- "$msg"
}

check_remote_clock() 
{
	time_diff_ok=2 # seconds
	integer -r time_diff=$[ $(ssh $R date -u '+%s') - $(date -u '+%s') ]
	(( $time_diff > $time_diff_ok || $time_diff < -$time_diff_ok )) &&
		ssh_notify critical "Remote clock deviates more than $time_diff_ok seconds (diff = $time_diff)."
}

mount_remote_fs() 
{
	local sshfs_opts="-o compression=yes -o idmap=user -o transform_symlinks" 
	local mnt_point=$local_home/mnt/$remote_hostname_cmd
	fusermount -u $mnt_point >&$n || true
	mkdir -p $mnt_point || { ssh_notify critical "Failed to create mount point \"$mnt_point\"." ; return ; }
	sshfs $=sshfs_opts $R:/ $mnt_point || { ssh_notify critical "sshfs failed." ; return ; }
	ssh_notify low "Successfully mounted sshfs."

	# Create second mount point with root access - if possible
	[[ $remote_username != "root" || $( ssh $R sudo id -u ) = 0 ]] || return 
	mnt_point=$mnt_point-ROOT
	fusermount -u $mnt_point >&$n || true
	mkdir -p $mnt_point || { ssh_notify critical "Failed to create mount point \"$mnt_point\"." ; return ; }

	# Login via localhost over control connection to ensure graceful shutdown of 
	# root-connection when disconnecting from host
	local ssh_cmd="ssh -J $R"
	ssh_cmd+=" -i $local_home/.ssh/hosts/$remote_hostname_cmd/id"
	ssh_cmd+=" -o HostKeyAlias=ROOT-$R"
	ssh_cmd+=" -o StrictHostKeyChecking=accept-new"

	sshfs $=sshfs_opts -o ssh_command=$ssh_cmd root@localhost:/ $mnt_point || 
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
	
	# Check if remote tun is available
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

uncloak_control_path()
{
	local -r cp="$local_home/.ssh/cp"
	local -r cph="$local_home/.ssh/cp_hashed"
	mkdir -p $cp $cph
	local -r cph_host=$cph/$C_hash
	[ -S $cph_host ] || 
	    { ssh_notify critical "Control path not found. (\"$cph_host\")"; return ; }
	ln -sf $cph_host $cp/$local_username@$local_hostname---$R:$remote_port || 
	    { ssh_notify critical "Failed to link hashed control path."; return ; }
}

main()
{
	ssh_notify low "LocalCommand: $@ ($#@) debug=\"$SSH_DEBUG\""
	(( $#@ >= 11 )) || return 

	C_hash=$1                 # %C
	local_home=$2             # %d
	remote_hostname=$3        # %h
	local_user_id=$4          # %i
	local_hostname=$5         # %L
	local_hostname_full=$6    # %l
	remote_hostname_cmd=$7    # %n
	remote_port=$8            # %p
	remote_username=$9; shift # %r
	local_tuntap=$9; shift    # %T
	local_username=$9         # %u

	# TODO: Check if adding '-p $remote_port' makes sense...
	R="$remote_username@$remote_hostname_cmd"
	echo "$(date '+%F %T') $R:$remote_port" >> ~/.ssh/host_history; ssh_notify low "Updated ssh host history." 

	sleep 0.3
	o=$( ssh -o BatchMode=yes -O check $R 2>&1 ) || 
		{ ssh_notify critical "Connection failed to multiplex: \"${o//[[:cntrl:]]/}\"" ; return 1 ; }

	check_remote_clock
	mount_remote_fs
	connect_tun
}

main $@
