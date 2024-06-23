#!/usr/bin/bash
if [ ! -z $TMUX ]; then
    if [ 1 -eq "$(tmux list-windows | wc -l)" ]; then
        tmux detach
        exit 1
    fi
fi
exit 0
