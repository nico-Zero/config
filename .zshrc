# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

GITSTATUS_LOG_LEVEL=DEBUG

# Set Config
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -e
zstyle :compinstall filename '/home/zero/.zshrc'

#Style
# autoload -Uz compinit
# autoload -Uz add-zsh-hook
# autoload -Uz vcs_info
# precmd () { vcs_info }
# _comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    '+r:|[._-]=* r:|=*' \
    '+l:|=*'
    zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
    zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
    zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

# Exports
export PYDEVD_DISABLE_FILE_VALIDATION=1
export ZSH="$HOME/.oh-my-zsh"
export TERMINAL="alacritty"
export SHELL="/usr/bin/zsh"
export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down'
export PAGER='less'
export BAT_PAGER="less -R -S -X -K"
export PATH="/home/$USER/anaconda3/bin/:$PATH"
export PATH="/home/$USER/.local/bin:/home/zero/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"
export PATH="$HOME/.cargo/bin:$PATH"
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
eval $(dbus-launch)
export DBUS_SESSION_BUS_ADDRESS
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus


plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    z
)

# Source:
source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
source ~/powerlevel10k/powerlevel10k.zsh-theme

# PreExec-Funcitons:
function preexec(){
    if [[ "$1" == *"--help"* ]]; then
        help=$(eval "$1")
        if [ ! -z "$help" ]; then
            echo "$help" | less
        else
            echo "$help"
        fi
        return 0
    fi
}

# Alias:
alias pp="shotwell *"
alias ls="eza --icons --group-directories-first -l --hyperlink"
alias :q="exit"
alias lsg="lsa | grep"
alias cht="bash ~/.config/LSD/cht.sh"
alias tls="tmux ls"
alias asdf="~/.config/LSD/exit.sh && exit"
alias cd="z"
alias cat="bat"
alias aic="ascii-image-converter"
alias trl="trash-list"
alias tre="trash-empty"
alias trp="trash-put"
alias trr="trash-restore"
alias trm="trash-rm"
alias rm="trash -v"
alias vi="nvim"
alias ff="fastfetch"
alias ani="ani-cli"
alias lg="lazygit"
alias tt="toipe"
alias emoji="rofi -show emoji"
alias calc="rofi -show calc"
alias j2p="/usr/bin/env bash ~/.config/LSD/jpg_to_png.sh"
alias cdh="cd ~"
alias p3="python3"
alias cc="clear"
alias nn="nvim"
alias ee="exit"
alias lsf="/usr/bin/ls | fzf"
alias nc="nvim --cmd 'cd ~/.config/nvim'"
alias mp="mypy"
alias pd="bash ~/.config/LSD/fzf_pydocs.sh"
alias update-pydoc-list="python3 -u /home/zero/.config/LSD/update_pydocs.py"
alias bb="btop --utf-force"
alias srm="nvim ~/.config/LSD/.harpoon_on_steroids_data.txt"
alias tmuxall="sh ~/.config/LSD/harpoon_on_steroids.sh tmuxall"
alias tmuxselect="sh ~/.config/LSD/harpoon_on_steroids.sh tmuxselect"
alias tmuxkill="sh ~/.config/LSD/harpoon_on_steroids.sh killselect"

# Bindkey:
bindkey '^ ' autosuggest-accept
bindkey -s '^f' "yy && clear^M"
bindkey -s '^[c' "ndir=\`fzf --walker=dir,hidden --walker-root=/ --reverse\` && cd \$ndir && clear || clear ^M"
bindkey -s '^[n' "ndir=\`fzf --walker=dir,hidden --walker-root=/ --reverse\` && cd \$ndir && clear && nvim || clear ^M"
bindkey -s '^g' "bash ~/.config/LSD/gitacp.sh^M"
bindkey -s '^[[1;5P' "cd ~/.config/nvim && nvim^M"
bindkey -s '^a' "bash ~/.config/LSD/harpoon_on_steroids.sh add^M"
bindkey -s '^e' "bash ~/.config/LSD/harpoon_on_steroids.sh gotoW^M"
bindkey -s '^s' "bash ~/.config/LSD/harpoon_on_steroids.sh gotoS^M"
bindkey -s '^[C' "bash ~/.config/LSD/harpoon_on_steroids.sh killall^M"
bindkey -s '^[h' "bash ~/.config/LSD/cht.sh^M"
bindkey -s '^[m' "bash ~/.config/LSD/cht.sh man^M"
bindkey -s '^[a' "ddgr^M"
bindkey -s '^[g' "lazygit^M"
bindkey -s '^[t' "toipe^M"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down
bindkey -s '^[b' "btop --utf-force^M"

# >>> conda initialize >>>
__conda_setup="$('/home/zero/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/zero/anaconda3/etc/profile.d/conda.sh" ]; then
        # . "/home/zero/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
        # export PATH="/home/zero/anaconda3/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup

# Yazi Config:
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Zoxide
eval "$(zoxide init zsh)"

eval $(thefuck --alias)
# export PATH="/home/zero/anaconda3/bin:$PATH" 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
