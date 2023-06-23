#!/bin/zsh

setopt errexit

: ${service:=reboot_offline}

service_path=/etc/systemd/system/$service.service
timer_path=/etc/systemd/system/$service.timer
script_path=/usr/local/bin/$service.sh

[[ -e $service_path ]] && {
	[[ $force = yes ]] || {
		print -u2 "Service \"$service\" already exists. Set \"force=yes\" to overwrite."
		exit 1
	}
	echo "Overwriting existing service \"$service\" at $service_path"
}

cat > $service_path <<-EOF_service
	[Unit]
	Description=Reboot if offline

	[Service]
	Type=oneshot
	ExecStart=$script_path

	[Install]
	WantedBy=network-online.target 
EOF_service

[[ -e $timer_path ]] && {
	[[ $force = yes ]] || {
		print -u2 "Timer for service \"$service\" already exists. Set \"force=yes\" to overwrite."
		exit 1
	}
	echo "Overwriting existing timer \"$service\" at $timer_path"
}

cat > $timer_path <<-EOF_timer
	[Unit]
	Description=Reboot if offline

	[Timer]
	OnCalendar=*:0/5
	# RandomizedDelaySec=10s
	# Persistent=true

	[Install]
	WantedBy=timers.target
EOF_timer

[[ -e $script_path ]] && {
	[[ $force = yes ]] || {
		print -u2 "Script for service \"$service\" already exists. Set \"force=yes\" to overwrite."
		exit 1
	}
	echo "Overwriting existing script for \"$service\" at $script_path"
}

cat > $script_path <<-EOF_script
	#!/bin/sh

	: \${remote_host:=1.1.1.1}
	: \${reboot_delay_seconds:=90}

	ping -W1 -c3 \$remote_host || {
		msg="Offline situation detected. Failed to ping \$remote_host. About to reboot in \$reboot_delay_seconds seconds. Kill pid \$\$ to prevent this."
		logger \$msg
		wall \$msg
		sleep \$reboot_delay_seconds
		reboot
	}
EOF_script
chmod +x  $script_path

sc="systemctl --full --no-pager"
$=sc daemon-reload
$=sc enable --now $service.service
$=sc enable --now $service.timer
$=sc list-timers $service
$=sc status $service
