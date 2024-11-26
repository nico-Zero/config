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
    if [[ $# -ne 0 ]]; then
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse -m --header="$1")
    else
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse -m)
    fi
    readarray -t choices_array <<< "$choices"
    echo "${choices_array[@]}"
}

fzf_select(){
    local active_paths=($(get_active_fzf_session))
    if [[ $# -ne 0 ]]; then
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse --header="$1")
    else
        local choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse)
    fi
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
        exit
        ;;

    gotoW)
        choice=($(fzf_select "Create Tmux Window"))
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
        exit
        ;;

    gotoS)
        choices=($(fzf_multi_select "Create Tmux Sessions"))
        choice_count=${#choices[@]}
        if [[ $choice_count -eq 1 ]]; then
            dirname="$(awk -F '/' '{print $NF}' <<< $choices | tr "." "_")"
            if [ ! -z $choices ]; then
                tmux has-session -t "$dirname" > /dev/null 2>&1 
                exitcode=$?
                if [ ! -z $TMUX ]; then
                    if [ 0 -eq $exitcode ]; then
                        tmux -u switch-client -t "$dirname"
                    else
                        new_session_switch $dirname $choices
                    fi
                else
                    if [ "nvim" == "$2" ]; then
                        if [ 0 -eq $exitcode ]; then
                            tmux -u attach-session -t "$dirname"
                        else
                            nvim_new_session_attach $dirname $choices
                        fi
                    else
                        if [ 0 -eq $exitcode ]; then
                            tmux -u attach-session -t "$dirname"
                        else
                            new_session_attach $dirname $choices
                        fi
                    fi
                fi
            fi
        elif [[ $choice_count -gt 1 ]]; then
            echo "CREATE SESSION ?"
            printf "%s\n" "${choices[@]}"
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
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
                echo "CREATION PROCESS COMPLETE"
            else
                echo "CANCELING THE SESSION CREATION PROCESS"
            fi
        fi
        exit
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
        echo "CREATION PROCESS COMPLETE"
        exit
        ;;

    deleteline)
        cp "$data_file_path" "${data_file_path}.bak"
        choice=($(fzf_multi_select "Delete a Line"))
        if [[ ${#choice[@]} -eq 0 ]]; then
            exit
        fi
        echo "Delete lines:"
        printf "%s\n" "${choice[@]}"
        read -p "Confirm(Y|n):- " confirm
        if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
            line_numbers=()
            for selected_line in "${choice[@]}"; do
                line_number=$(grep -Fnx "$selected_line" "$data_file_path" | cut -d: -f1)
                if [[ -n $line_number ]]; then
                    line_numbers+=($line_number)
                fi
            done
            for line in $(printf "%s\n" "${line_numbers[@]}" | sort -nr); do
                sed -i "${line}d" "$data_file_path"
            done
            echo "DELETION PROCESS COMPLETE"
        else
            echo "CANCELING THE DELETE PROCESS"
        fi
        exit
        ;;

    killselect)
        active_paths=($(get_active_fzf_session))
        choices=$(cat "$data_file_path" | fzf_path_highlight "${active_paths[@]}" | fzf --ansi --reverse -m --header="Select to Kill")
        if [[ ${#choices} -ne 0 ]]; then
            readarray -t choices_array <<< "$choices"
            echo "Active Sessions:-"
            printf "%s\n" "${choices_array[@]}"
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
                for path in ${choices_array[@]}; do
                    if [[ " ${active_paths[*]} " == *" $path "* ]]; then
                        dirname="$(awk -F '/' '{print $NF}' <<< $path | tr "." "_")"
                        tmux kill-session -t "$dirname"
                        echo "Killed session :- $dirname at $path"
                    else
                        echo "Not session :- $dirname at $path"
                    fi
                done
                echo "KILLING PROCESS COMPLETE"
            else
                echo "CANCELING THE KILLING PROCESS..."
            fi
        fi
        exit
        ;;

    killall)
        active_session="$(tmux list-sessions 2>/dev/null)"
        if [[ ${#active_session} -ne 0 ]]; then
            echo "Active Sessions:-"
            echo "$active_session"
            read -p "Confirm(Y|n):- " confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "y" ]] || [[ "$confirm" == "" ]]; then
                tmux kill-session -a > /dev/null
                tmux kill-session > /dev/null
                echo "KILLING PROCESS COMPLETE"
            else
                echo "CANCELING THE KILLING PROCESS..."
            fi
        else
            echo "No Active Sessions"
        fi
        exit
        ;;
    *)
        echo "Invalid command..."
        exit
esac
