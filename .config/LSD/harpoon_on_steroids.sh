#!/use/bin/bash

data_file=~/.config/LSD/.harpoon_on_steroids_data.txt

new_session_attach() {
    tmux -u new -s "$1" -c "$2" -d
    tmux -u new-window -t "$1" -n "$(echo $SHELL | awk -F '/' '{print $NF}')" -c "$2" -d 
    tmux -u attach-session -t "$1"
}

new_session_switch() {
    tmux -u new -s "$1" -c "$2" -d
    tmux -u new-window -t "$1" -n "$(echo $SHELL | awk -F '/' '{print $NF}')" -c "$2" -d
    tmux -u switch-client -t "$dirname"
}


nvim_new_session_attach() {
    tmux -u new -s "$1" -c "$2" -d 'nvim'
    tmux -u new-window -t "$1" -n "$(echo $SHELL | awk -F '/' '{print $NF}')" -c "$2" -d 
    tmux -u attach-session -t "$1"
}

nvim_new_session_switch() {
    tmux -u new -s "$1" -c "$2" -d 'nvim'
    tmux -u new-window -t "$1" -n "$(echo $SHELL | awk -F '/' '{print $NF}')" -c "$2" -d
    tmux -u switch-client -t "$dirname"
}


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
                    new_session_attach $dirname $choice
                fi
            fi
        fi
        ;;
    gotoS)
        choice=$(cat "$data_file" | fzf --reverse) && dirname="$(awk -F '/' '{print $NF}' <<< $choice | tr "." "_")"
        if [ ! -z $choice ]; then
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ ! -z $TMUX ]; then
                if [ 0 -eq $exitcode ]; then
                    tmux -u switch-client -t "$dirname"
                else
                    new_session_switch $dirname $choice
                fi
            else
                if [ "nvim" == "$2" ]; then
                    if [ 0 -eq $exitcode ]; then
                        tmux -u attach-session -t "$dirname"
                    else
                        nvim_new_session_attach $dirname $choice
                    fi
                else
                    if [ 0 -eq $exitcode ]; then
                        tmux -u attach-session -t "$dirname"
                    else
                        new_session_attach $dirname $choice
                    fi
                fi
            fi
        fi
        ;;
    tmuxall)
        mapfile -t data < "$data_file"
        for path in ${data[@]}; do
            dirname="$(awk -F '/' '{print $NF}' <<< $path | tr "." "_")"
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ 0 -eq $exitcode ]; then
                echo "Already session :- $dirname at $path"
            else
                tmux -u new -s "$dirname" -c "$path" -d
                tmux -u new-window -t "$dirname" -n "$(echo $SHELL | awk -F '/' '{print $NF}')" -c "$path" -d
                echo "Created session :- $dirname at $path"
            fi
        done
        ;;
    tmuxselect)
        choices=$(cat "$data_file" | fzf --reverse -m)
        readarray -t data <<< "$choices"
        for path in ${data[@]}; do
            dirname="$(awk -F '/' '{print $NF}' <<< $path | tr "." "_")"
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ 0 -eq $exitcode ]; then
                echo "Already session :- $dirname at $path"
            else
                tmux -u new -s "$dirname" -c "$path" -d
                tmux -u new-window -t "$dirname" -n "$(echo $SHELL | awk -F '/' '{print $NF}')" -c "$path" -d
                echo "Created session :- $dirname at $path"
            fi
        done
        ;;
    killall)
        tmux kill-session -a
        tmux kill-session
        ;;
    killselect)
        mapfile -t filedata < "$data_file"
        preview=("Sessions :-")
        for path in ${filedata[@]}; do
            dirname="$(awk -F '/' '{print $NF}' <<< $path | tr "." "_")"
            tmux has-session -t "$dirname" > /dev/null 2>&1 
            exitcode=$?
            if [ 0 -eq $exitcode ]; then
                preview+=("\n$path")
            fi
        done
        IFS=""
        choices=$(cat "$data_file" | fzf --reverse -m --preview "echo '${preview[*]}'")
        readarray -t data <<< "$choices"
        for path in ${data[@]}; do
            dirname="$(awk -F '/' '{print $NF}' <<< $path | tr "." "_")"
            tmux kill-session -t "$dirname"
            echo "Killed session :- $dirname at $path"
        done
        ;;
    *)
        echo "Invalid command..."
esac
