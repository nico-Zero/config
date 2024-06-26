#!/usr/bin/bash

# tmux has-session -t nico > /dev/null 2>&1
# exitcode=$?
#
# if [ 0 -eq $exitcode ]; then
#     echo "Session exists."
# else
#     echo "Session does not exist."
# fi
#
# if [ 0 -eq $exitcode ]; then
#     echo "Session exists."
# else
#     echo "Session does not exist."
# fi
if [ 1 -eq "$(tmux display-message -p "#{pane_index}")" ]; then
    echo "Yes"
else
    echo "No"
fi
echo "$(tmux display-message -p "#{pane_index}")"
