#!/bin/sh
set -x
backup_path="/mnt/BACKUP/$HOSTNAME/$USER"
sudo mkdir -p $backup_path 
sudo cp -al $backup_path $backup_path-$(date '+%F__%T')
sudo rsync \
	$rsync_options \
	--exclude-from $HOME/.dotfiles/rsync-homedir-excludes.txt \
	--force \
	-ax $HOME/ $backup_path/
echo "rsync = $?"
echo "backup_path = $backup_path"
echo "rsync_options = $rsync_options"
