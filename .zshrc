#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ====================================================================
# --- ZSH HISTORY & COMPLETION OPTIONS ---
# ====================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history across all open Kitty tabs
setopt HIST_IGNORE_DUPS       # Do not record duplicate consecutive commands
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt AUTO_CD                # Type a folder name to cd into it automatically

# Enable modern case-insensitive tab completion with arrow-key menus
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable Ctrl+Left / Ctrl+Right word jumping and Delete/Home/End keys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# ====================================================================
# --- HSIN CRIMSON & GOLD PROMPT THEME ---
# ====================================================================
setopt PROMPT_SUBST

# Zsh requires %F{#hex} ... %f for truecolor prompt formatting
PROMPT='%F{#2a2d3d}[%F{#f4a261}%n%F{#a8dedc}@%F{#f4a261}%m%F{#2a2d3d}] %F{#a8dedc}%~ %F{#d62828}❯%f '

# ====================================================================
# --- ALIASES ---
# ====================================================================
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias ll='ls -lah'                 # Long format, showing all hidden files & readable sizes
alias l='ls -F'                    # Short format classified list
alias la='ls -A'                   # Show hidden files, but skip . and ..

alias fastfetch='clear && fastfetch'

# Faster Directory Traversal
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'            # Creates parent directories if missing and prints confirmation

alias rm='rm -i'                   # Ask for confirmation before destroying any file
alias cp='cp -i'                   # Prompt before overwriting a file during copy
alias mv='mv -i'                   # Prompt before overwriting a file during a move

# Hyprland & UWSM
alias hlog="uwsm stop"
alias hcheck="uwsm check may-start"

alias ff="uwsm app -- firefox"     # Fixed typo from 'uswm'
alias fm="uwsm app -- dolphin"     # Fixed typo from 'uswm'
alias menu="uwsm app -- hyprlauncher"
alias lock="uwsm app -- hyprlock"


alias edithypr="nano ~/.config/hypr/hyprland.lua"
alias editkitty="nano ~/.config/kitty/kitty.conf"
alias edittk="nano ~/.config/hypr/hyprtoolkit.conf"
alias editdunst="nano ~/.config/dunst/dunstrc"
alias editwaybar="nano ~/.config/waybar/config.jsonc"
alias editwaybarcss="nano ~/.config/waybar/style.css"

alias reloadlauncher="killall hyprlauncher 2>/dev/null; sleep 1; uwsm app -- hyprlauncher -d &"
alias reloaddunst="killall dunst && uwsm app -- dunst &"
alias reloadwaybar="killall waybar && uwsm app -- waybar &"
alias reloadidle="killall hypridle && uwsm app -- hypridle &"
alias reloadall="reloadlauncher && reloaddunst && reloadwaybar && reloadidle"

alias testnotif="dunstify 'System Synced' 'Notifications are working.'"
alias testcrit="dunstify -u critical 'Battery Low' 'ASUS power matrix dropping below safe thresholds.'"

# Arch Maintenance
alias cleanpkg="paccache -d -k 2"           # Safe simulation dry-run
alias cleanpkgforce="sudo paccache -r -k 2" # Actual forced execution purge
alias checktimer="systemctl status paccache.timer paccache.service"
alias update="sudo pacman -Syu"

# Dotfiles Bare Git Repo
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# ====================================================================
# --- PLUGINS & STARTUP ---
# ====================================================================
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fastfetch
alias server="uwsm app -- dolphin ~/M710q/Videos"
setopt interactivecomments
alias reloadbar='killall waybar; uwsm app -- waybar >/dev/null 2>&1 & disown'
export PATH="$HOME/.local/bin:$PATH"
