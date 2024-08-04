#!/usr/bin/bash
if [ ! -z $TMUX ] && [ -z $NVIM ]; then
    # # The commanted code for when you want to exit detach if only 1 window is left open.
    # if [ 1 -eq "$(tmux list-windows | wc -l)" ]; then
    #     clear
    #     tmux detach
    #     exit 1
    # fi


    if [ 1 -eq "$(tmux display-message -p "#I")" ] && [ 1 -eq "$(tmux display-message -p "#{pane_index}")" ]; then
        clear
        tmux detach
        exit 1
    fi
fi
exit 0
