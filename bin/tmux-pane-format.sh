tmux set-window-option pane-border-format \
'#{pane_id}'\
'(#{pane_width}x#{pane_height})'\
': '\
'#{pane_tty}'\
': '\
'#{pane_current_command}(#{pane_pid}) '\
'#{pane_current_path} '\
'['\
'E:#{pane_synchronized} '\
'D:#{pane_dead} '\
'R:#{pane_dead_status} '\
']'\
