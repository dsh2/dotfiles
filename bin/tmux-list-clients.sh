#!/bin/sh

echo "client_activity	client_created	client_tty	client_width	client_height	client_cell_height	client_cell_width	client_pid	client_uid	client_user	client_control_mode	client_discarded	client_flags	client_key_table	client_last_session	client_name	client_prefix	client_readonly	client_session	client_termfeatures	client_termname	client_termtype	client_utf8"

tmux list-clients -F '#{client_activity}	#{client_created}	#{client_tty}	#{client_width}	#{client_height}	#{client_cell_height}	#{client_cell_width}	#{client_pid}	#{client_uid}	#{client_user}	#{client_control_mode}	#{client_discarded}	#{client_flags}	#{client_key_table}	last=#{client_last_session}	#{client_name}	#{client_prefix}	#{client_readonly}	#{client_session}	#{client_termfeatures}	#{client_termname}	#{client_termtype}	#{client_utf8}'
