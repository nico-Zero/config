#!/usr/bin/env bash
# Setup for Arch-linux...

function ctrl_c() {
    echo "Exiting script..."
    exit 1
}
trap ctrl_c INT

echo "Updating System..."
sudo pacman -Syu

echo "Install Pre-Req..."
echo "y" | sudo pacman -S alacritty
echo "y" | sudo pacman -S screenkey
echo "y" | sudo pacman -S btop
echo "y" | sudo pacman -S neovim
echo "y" | sudo pacman -S eza
echo "y" | sudo pacman -S vim
echo "y" | sudo pacman -S fzf
echo "y" | sudo pacman -S yazi
echo "y" | sudo pacman -S xclip
echo "y" | sudo pacman -S unzip
echo "y" | sudo pacman -S wget
echo "y" | sudo pacman -S curl
echo "y" | sudo pacman -S gzip
echo "y" | sudo pacman -S tar
echo "y" | sudo pacman -S bash
echo "y" | sudo pacman -S zsh
echo "y" | sudo pacman -S sh
echo "y" | sudo pacman -S firefox
echo "y" | sudo pacman -S nvtop
echo "y" | sudo pacman -S fastfetch
echo "y" | sudo pacman -S glxinfo
echo "y" | sudo pacman -S entr
echo "y" | sudo pacman -S figlet
echo "y" | sudo pacman -S trash-cli
echo "y" | sudo pacman -S bat
echo "y" | sudo pacman -S rofi
echo "y" | sudo pacman -S vlc
echo "y" | sudo pacman -S libreoffice-still
echo "y" | sudo pacman -S ddgr
echo "y" | sudo pacman -S progress
echo "y" | sudo pacman -S i3-gaps
echo "y" | sudo pacman -S polybar
echo "y" | sudo pacman -S nitrogen
echo "y" | sudo pacman -S bluez
echo "y" | sudo pacman -S bluez-utils
echo "y" | sudo pacman -S brightnessctl
echo "y" | sudo pacman -S feh
echo "y" | sudo pacman -S xorg-xinput
echo "y" | sudo pacman -S blueman
echo "y" | sudo pacman -S xsettingsd
echo "y" | sudo pacman -S thefuck
echo "y" | sudo pacman -S lazygit
echo "y" | sudo pacman -S conky
echo "y" | sudo pacman -S ntfs-3g
echo "y" | sudo pacman -S qt5ct
echo "y" | sudo pacman -S lxappearance
echo "y" | sudo pacman -S xdotool
echo "y" | sudo pacman -S xorg-xbacklight
echo "y" | sudo pacman -S gucharmap
echo "y" | sudo pacman -S gimp
echo "y" | sudo pacman -S rofi-emoji
echo "y" | sudo pacman -S rofi-calc
echo "y" | sudo pacman -S alsa-utils
echo "y" | sudo pacman -S flameshot
echo "y" | sudo pacman -S luarocks
echo "y" | sudo pacman -S obs-studio
echo "y" | sudo pacman -S xorg-xdpyinfo
echo "y" | sudo pacman -S acpi
echo "y" | sudo pacman -S git
echo "y" | sudo pacman -S tmux
echo "y" | sudo pacman -S grep
echo "y" | sudo pacman -S ripgrep
echo "y" | sudo pacman -S nushell
echo "y" | sudo pacman -S jq
echo "y" | sudo pacman -S kitty
echo "y" | sudo pacman -S man
echo "y" | sudo pacman -S go
echo "y" | sudo pacman -S nodejs
echo "y" | sudo pacman -S zoxide
echo "y" | sudo pacman -S viu
echo "y" | sudo pacman -S wezterm
echo "y" | sudo pacman -S picom
echo "y" | sudo pacman -S gcc clang libc++ cmake ninja libx11 libxcursor mesa-libgl fontconfig
echo "y" | sudo pacman -Sy python-pluggy python-pycosat python-ruamel-yaml 
echo "y" | sudo pacman -Sy mesa-demos
echo "y" | sudo pacman -Sy intel-media-driver

read -p "Install Yay (Y|n)? " install_yay
if [ -z $install_yay ] || [ "${install_yay,,}" == "y"]; then
    echo "Install Yay..."
    sudo pacman -S --needed base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    cd ~
fi

echo "Installing Brew..."
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
/usr/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing package from Brew..."
/home/linuxbrew/.linuxbrew/bin/brew install gcc
/home/linuxbrew/.linuxbrew/bin/brew install nodejs
/home/linuxbrew/.linuxbrew/bin/brew install wtf
/home/linuxbrew/.linuxbrew/bin/brew install toipe
/home/linuxbrew/.linuxbrew/bin/brew install php
/home/linuxbrew/.linuxbrew/bin/brew install java
/home/linuxbrew/.linuxbrew/bin/brew install tree-sitter
/home/linuxbrew/.linuxbrew/bin/brew install perl
/home/linuxbrew/.linuxbrew/bin/brew install composer

# Install SSH key in system.
echo "If have the ssh-key setup the just press enter."
echo -n "If not then want to setup (y|N):- "
read setup_ssh

if [ "${setup_ssh,,}" == "y" ]; then
    ssh_add_function () {
        echo "Enter the absolute-dir-path and don't put '/' or '.' in the end of path."
        take_path (){
            read -p "Enter ssh-key dir path:- " path
            read -p "Confirm '$path' this is the path(Y|n)? " confirm    
            if [ "${confirm,,}" == "n" ]; then
                take_path
            fi
        }
        take_path
        ssh_dir="$HOME/.ssh"
        mkdir -p $ssh_dir
        cp -r "$path/." $ssh_dir 
        ssh_key_file="$(find $ssh_dir -type f | fzf)"
        if [ ! -z $ssh_key_file ]; then
            eval "$(ssh-agent -s)"
            ssh-add $ssh_key_file
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

# Install config from github or not?
read -p "Install config from github (y|N):- " install_config
if [ "${install_config,,}" == "y" ]; then
    echo "Seting Up config..."
    rm -rf ~/.config/rofi/
    rm -rf ~/.config/i3/
    rm -rf ~/.icons/
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    cd ~
    rm .zshrc
    git init
    git branch -M main
    git config --global user.email "zandaxheart955@gmail.com"
    git config --global user.name "nico-Zero"
    git remote add origin git@github.com:nico-Zero/config.git
    git fatch
    git reset origin/main
    git checkout -t origin/main
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    git clone https://github.com/nico-Zero/nvim.git ~/.config/nvim/
fi

echo "Install Anaconda..."
wget -P ~/Downloads/ https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
chmod +x ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh
bash ~/Downloads/Anaconda3-2024.06-1-Linux-x86_64.sh
conda init

echo "Installing Package from Pacman..."
sudo pacman -S lua
sudo pacman -S cargo
sudo pacman -S java
sudo pacman -S julia
sudo pacman -S ruby

echo "Install Package from Yay...(Will have to do it manually.)"
yay -S brave
yay -S whatsapp-for-linux
yay -S signal-desktop
yay -S ascii-image-converter
yay -S ani-cli
yay -S getnf
yay -S rxvt-unicode
yay -S also-utils
yay -S pywal
yay -S spotify-adblock-git
yay -S unicode
yay -S autotiling-rs-git
yay -S ascii-draw
yay -S aseprite
yay -S kotatsu-dl-git
yay -S tgpt-bin

# Install betterlockscreen into system.
git clone https://github.com/Raymo111/i3lock-color.git; cd ~/i3lock-color/; ./install-i3lock-color.sh
rm -rf ~/i3lock-color
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
betterlockscreen -u ~/wallpaper/anime-girl-red-eye-tattoo-sword-4k-wallpaper-uhdpaper.com-310@0@j.jpg

echo "Installing Fonts..."
echo "1-67" | getnf
echo "-------------------------------------------------------------------------------------------------------"
echo "Do all this First..."
echo "tmux source ~/.config/tmux/tmux.conf (inside tmux)"
echo "Run <Ctrl-b I> inside tmux."
echo "make a shortcut <Alt-Ctrl-l> to Lunch alacritty"
echo "make a shortcut <Alt-Space> to Lunch rofi (command:- rofi -show drun)"
echo "Open Nvim and Wait for it to config itself."
echo "And then You are all done."
echo "Run this command after terminal restart..."
echo "conda update conda"
echo "conda install python=3.11"
echo "conda install build"
echo "pip install installer"
echo "pip install neovim"
echo "pip install PyGObject"
echo "npm install -g neovim"
echo "gem install neovim"
echo "conda install -c conda-forge libstdcxx-ng libffi"
echo "Add This line (UUID=A232F5EE32F5C6F7 /mnt/Nova ntfs defaults  0  2) in /etc/fstab"
echo "Add This line (SUBSYSTEM=='backlight', RUN+='/usr/bin/chmod 666 /sys/class/backlight/%k/brightness') in /etc/udev/rules.d/99-backlight.rules"
echo "run 'sudo udevadm control --reload' and 'sudo udevadm trigger'"
ehco "After grub setup run 'grub-mkconfig -o /path/to/grub.cfg'"
echo "Restart the terminal."
