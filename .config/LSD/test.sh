# # #!/usr/bin/bash
# #
# # # # Function to handle SIGINT (Ctrl+C)
# # # function ctrl_c() {
# # #     echo "Exiting script..."
# # #     exit 1
# # # }
# # #
# # # # Trap SIGINT
# # # trap ctrl_c INT
# # #
# # # # Your script logic here
# # # echo "Running script..."
# # #
# # # # Example loop (replace with your script logic)
# # # while true; do
# # #     sleep 1
# # # done
# # #
# #
# # #!/usr/bin/env bash
# #
# # # Get the layout tree and find the focused container
# # focused_container=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]) | select(.focused == true)')
# #
# # # Get the split mode of the focused container
# # split_mode=$(echo "$focused_container" | jq -r '.layout')
# #
# # # Print the split mode
# # echo "Current split mode: $split_mode"
# #
#
# # read -p "alskdfjl:- " path
# # dd="$HOME/.config/nigger"
# # mkdir -p $dd
# # cp -r "$path/." $dd 
#
# autos () {
#     printf "r/restart <\nm/manully\n"
#     read -p "choice:- " input
#
#     if [ -z $input ] || [ "${input,,}" == "manully" ] || [ "${input,,}" == "m" ]; then
#         eval zsh
#         echo "hello"
#     else
#         echo $input
#         echo "hello"
#         autos
#     fi
# }
# autos
# # ssh_add (){
# #     dd="$HOME/.ssh"
# #     n="$(find $dd -type f | fzf)"
# #     if [ ! -z $n ]; then
# #         echo $n
# #         return 0
# #     else
# #         eval zsh
# #         echo "welcome back..."
# #         return 1
# #     fi
# # }
# # ssh_add
echo "If have the ssh-key setup the just press enter."
echo -n "If not then want to setup (y|N):- "
read setup_ssh

if [ "${setup_ssh,,}" == "y" ]; then
    ssh_add_function () {
        echo "Enter the absolute-dir-path and don't put '/' or '.' in the end of path."
        read -p "Enter ssh-key dir path:- " path
        ssh_dir="$HOME/.ssh"
        mkdir -p $ssh_dir
        cp -r "$path/." $ssh_dir 
        ssh_key_file="$(find $ssh_dir -type f | fzf)"
        if [ ! -z $ssh_key_file ]; then
            eval "$(ssh-agent -s)"
            sudo ssh-add $ssh_key_file
        else
            restart_or_not () {
                echo "An error occur while setting up ssh_key,"
                echo "Restart ssh-key setup process or do it Manually."
                printf "\n *  r/restat <<\n    m/manually\n\n"
                read -p "choice:- " r_m
                if [ -z $r_m ] || [ "$(r_m)" == "m" ] || [ "$(r_m)" == "manually" ]; then
                    eval zsh
                    read -p "Is setup Done (Y|n)? " done
                    if [ "${done,,}" == "n" ]; then
                        restart_or_not
                    fi
                else
                    ssh_add_function
                fi
            }
            restart_or_not
        fi
    } 
    ssh_add_function
    echo "SSH setup is done."
fi


