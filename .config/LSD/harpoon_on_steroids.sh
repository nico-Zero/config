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
        choice=$(cat "$data_file" | fzf --reverse) && dirname="$(awk -F "/" '{print $NF}' <<< $choice | tr "." "_")"
        if [ ! -z $choice ]; then
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ ! -z $TMUX ]; then
                tmux -u new-window -c "$choice"
            else
                if [ 0 -eq $exitcode ]; then
                    tmux -u attach-session -t "$dirname"
                else
                    tmux -u new -s "$dirname" -c "$choice"
                fi
            fi
        fi
        ;;
    gotoS)
        choice=$(cat "$data_file" | fzf --reverse) && dirname="$(awk -F "/" '{print $NF}' <<< $choice | tr "." "_")"
        if [ ! -z $choice ]; then
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ ! -z $TMUX ]; then
                if [ 0 -eq $exitcode ]; then
                    tmux -u switch-client -t "$dirname"
                else
                    tmux -u new-window -c "$choice"
                fi
            else
                if [ "nvim" == "$2" ]; then
                    if [ 0 -eq $exitcode ]; then
                        tmux -u attach-session -t "$dirname" \; send-keys "nvim" C-m
                    else
                        tmux -u new -s "$dirname" -c "$choice" \; send-keys "nvim" C-m
                    fi
                else
                    if [ 0 -eq $exitcode ]; then
                        tmux -u attach-session -t "$dirname"
                    else
                        tmux -u new -s "$dirname" -c "$choice"
                    fi
                fi
            fi
        fi
        ;;
    *)
        echo "Invalid command..."
esac
