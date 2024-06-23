#!/use/bin/bash

data_file=~/.config/LSD/.harpoon_on_steroids_data.txt

case "$1"
in
    add)
        if grep -Fxq "$(pwd)" "$data_file"; then
            echo "Already exists..."
        else
            echo "$(pwd)" >> "$data_file"
            echo "Added: $(pwd) -> List..."
        fi
        ;;
    gotoW)
        if [ ! -z $TMUX ]; then
            choice=$(cat "$data_file" | fzf --reverse) && tmux new-window -c "$choice"
        fi
        clear
        ;;
    gotoS)
        choice=$(cat "$data_file" | fzf --reverse) && dirname="$(awk -F "/" '{print $NF}' <<< $choice)"
        if [ ! -z $choice ]; then
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ ! -z $TMUX ]; then
                if [ 0 -eq $exitcode ]; then
                    tmux switch-client -t "$dirname" \; send-keys "nvim" C-m
                else
                    tmux new-window -c "$choice"
                fi
            else
                if [ 0 -eq $exitcode ]; then
                    tmux attach-session -t "$dirname" \; send-keys "nvim" C-m
                else
                    tmux new -s "$dirname" -c "$choice" \; send-keys "nvim" C-m
                fi
            fi
        fi
        clear
        ;;
    *)
        echo "fuck you"
esac
