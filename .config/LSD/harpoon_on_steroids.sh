#!/use/bin/bash

data_file_path=~/.config/LSD/.harpoon_on_steroids_data.txt

fzf_path_highlight() {
    local values=("$@")
    while ifs= read -r line; do
        if [[ " ${values[*]} " == *" $line "* ]]; then
            echo -e "\e[1;32m$line\e[0m"
        else
            echo "$line"
        fi
    done
}

get_active_fzf_session(){
    local active_session="$(tmux list-sessions -F '#{pane_current_path}' 2>/dev/null)"
    readarray -t data <<< "$active_session"
    echo "${active_session[@]}"
}

fzf_multi_select(){
    local active_paths=($(get_active_fzf_session))
    local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse -m)
    readarray -t choices_array <<< "$choices"
    echo "${choices_array[@]}"
}

fzf_select(){
    local active_paths=($(get_active_fzf_session))
    local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse)
    echo "$choices"
}

new_session_attach() {
    tmux -u new -s "$1" -c "$2" -d
    tmux -u new-window -t "$1" -n "Terminal" -c "$2" -d 
    tmux -u attach-session -t "$1"
}

new_session_switch() {
    tmux -u new -s "$1" -c "$2" -d
    tmux -u new-window -t "$1" -n "Termianl" -c "$2" -d
    tmux -u switch-client -t "$dirname"
}

nvim_new_session_attach() {
    tmux -u new -s "$1" -c "$2" -d 'nvim'
    tmux -u new-window -t "$1" -n "Termianl" -c "$2" -d 
    tmux -u attach-session -t "$1"
}

nvim_new_session_switch() {
    tmux -u new -s "$1" -c "$2" -d 'nvim'
    tmux -u new-window -t "$1" -n "Termianl" -c "$2" -d
    tmux -u switch-client -t "$dirname"
}

case "$1"
in
    add)
        if grep -Fxq "$(pwd)" "$data_file_path"; then
            echo "Already exists..."
        else
            echo "$(pwd)" >> "$data_file_path"
            echo "Added: $(pwd) -> List..."
        fi
        ;;

    gotoW)
        choice=($(fzf_select))
        dirname="$(awk -F "/" '{print $NF}' <<< $choice | tr "." "_")"
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
        choice=($(fzf_select))
        dirname="$(awk -F '/' '{print $NF}' <<< $choice | tr "." "_")"
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

    tmuxselect)
        choices=($(fzf_multi_select))
        for path in ${choices[@]}; do
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

    tmuxall)
        mapfile -t data < "$data_file_path"
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

    killselect)
        active_paths=($(get_active_fzf_session))
        choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse -m)
        readarray -t choices_array <<< "$choices"
        for path in ${choices_array[@]}; do
            if [[ " ${active_paths[*]} " == *" $path "* ]]; then
                dirname="$(awk -F '/' '{print $NF}' <<< $path | tr "." "_")"
                tmux kill-session -t "$dirname"
                echo "Killed session :- $dirname at $path"
            else
                echo "Not session :- $dirname at $path"
            fi
        done
        ;;

    killall)
        tmux kill-session -a > /dev/null 2>&1
        tmux kill-session > /dev/null 2>&1
        exitcode=$?
        if [ 1 -eq $exitcode ]; then
            echo "No Sessions"
        else
            echo "Killed all Sessions"
        fi
        ;;
    *)
        echo "Invalid command..."
esac
