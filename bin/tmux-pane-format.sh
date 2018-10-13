tmux set-window-option pane-border-format \
'['\
'#{pane_tty}'\
': '\
'#{pane_current_command} (#{pane_pid})'\
' '\
'#{pane_current_path}'\
' '\
'#{pane_width}x#{pane_height}'\
' '\
'#{pane_id}'\
'#{?pane_synchronized, SYNC,}'\
']'\
