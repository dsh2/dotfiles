#!/usr/bin/env bash

init_focuslastwindow=(
  chain
    # quit existing instances of loop below
    , emit_hook quit_focuslastwindow
    # if the key is pressed
    , keybind Alt-Tab
        # read the content of the my_lastwin attribute
        substitute LASTWIN my_lastwin
            # and jump there
            jumpto LASTWIN
    # create necessary attributes, but do not fail if they already exist
    , silent try new_attr string my_lastwin
    , silent try new_attr string my_curwin
    # fill them with the current window id
    , and ,, silent attr clients.focus
          ,, substitute WIN clients.focus.winid set_attr my_curwin WIN
          ,, substitute WIN clients.focus.winid set_attr my_lastwin WIN
)

# run the initialization
herbstclient "${init_focuslastwindow[@]}"

herbstclient -i '(focus_changed|tag_changed|reload|quit_focuslastwindow)' | \
    while read h winid t ; do
        case "$h" in
	    # TODO: handle tag_changed to set winid to hmm...
            focus_changed)
                # never feed an 'unfocused' state into the queue
                # if a window is focused, shift the content of my_curwin into
                # my_lastwin. Note that we use $winid here and not the content
                # of clients.focus.winid in order to avoid race conditions.
                [[ "$winid" != "0x0" ]] && \
                herbstclient and \
                    , substitute WIN my_curwin set_attr my_lastwin WIN \
                    , set_attr my_curwin "$winid"
                ;;
            *)  # on any other hook, quit this loop. Note that the idling
                # herbstclient still lives until the next time a hook arrives
                # and then quits because it can not write to stdout anymore
                break ;;
        esac
    done

