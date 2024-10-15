active_paths=(
    "/home/zero/.config/alacritty"
    "/home/zero/.config/nvim"
)

# Function to highlight active paths
highlight_paths(values) {
    while ifs= read -r line; do
        if [[ " ${values[*]} " == *" $line "* ]]; then
            echo -e "\e[1;32m$line\e[0m"  # highlight in green
        else
            echo "$line"
        fi
    done
}

printf "%s\n" \
    "/home/zero" \
    "/home/zero/.config/LSD" \
    "/home/zero/.config/alacritty" \
    "/home/zero/.config/rofi" \
    "/home/zero/.config" \
    "/home/zero/.config/tmux" \
    "/home/zero/.config/nvim" \
    "/home/zero/.config/i3" \
    "/home/zero/.config/polybar" \
    "/home/zero/.config/picom" | highlight_paths(values) | fzf --ansi --preview 'echo {}' \
    --height 40% --reverse --inline-info

