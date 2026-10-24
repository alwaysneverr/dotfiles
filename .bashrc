#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

alias rm='rm -i'      # Ask for confirmation before destroying any file
alias cp='cp -i'      # Prompt before overwriting a file during copy
alias mv='mv -i'      # Prompt before overwriting a file during a move

# ====================================================================
# --- HSIN CRIMSON & GOLD PS1 TERMINAL PROMPT THEME ---
# ====================================================================

# ANSI Color Token Definitions (Matching Hsin Palette)
COLOR_CRIMSON="\[\033[38;2;214;40;40m\]"   # #d62828 (Hsin Crimson)
COLOR_GOLD="\[\033[38;2;244;162;97m\]"     # #f4a261 (Amber Gold)
COLOR_SILVER="\[\033[38;2;168;222;220m\]"   # #a8dedc (Pale Silvery Blue)
COLOR_DARK="\[\033[38;2;42;45;61m\]"       # #2a2d3d (Alternate Base Slate)
COLOR_RESET="\[\033[0m\]"

# The Custom Prompt Layout (Clean, Single Line, Non-Spammy)
# Shows: [username@hostname] [current_directory] ❯ 
PS1="${COLOR_DARK}[${COLOR_GOLD}\u${COLOR_SILVER}@${COLOR_GOLD}\h${COLOR_DARK}] ${COLOR_SILVER}\w ${COLOR_CRIMSON}❯${COLOR_RESET} "

fastfetch

alias hlog="uwsm stop"
alias hcheck="uwsm check may-start"

alias ff="uswm app -- firefox"
alias fm="uswm app -- dolphin"
alias menu="uwsm app -- hyprlauncher"
alias lock="uwsm app -- hyprlock"

alias server="uwsm app -- dolphin ~/M710q/Videos"

alias edithypr="nano ~/.config/hypr/hyprland.lua"
alias editkitty="nano ~/.config/kitty/kitty.conf"
alias edittk="nano ~/.config/hypr/hyprtoolkit.conf"
alias editdunst="nano ~/.config/dunst/dunstrc"
alias editwaybar="nano ~/.config/waybar/config.jsonc"
alias editwaybarcss="nano ~/.config/waybar/style.css"

alias reloadlauncher="killall hyprlauncher && hyprlauncher -d"
alias reloaddunst="killall dunst && uwsm app -- dunst &"
alias reloadwaybar="killall waybar && uwsm app -- waybar &"
alias reloadidle="killall hypridle && uwsm app -- hypridle &"
alias reloadall="reloadlauncher && reloaddunst && reloadwaybar && reloadidle"

alias testnotif="dunstify 'System Synced' 'Connected to Hsin Samba Server node safely.'"
alias testcrit="dunstify -u critical 'Battery Low' 'ASUS power matrix dropping below safe thresholds.'"

alias cleanpkg="paccache -d -k 2"       # Safe simulation dry-run
alias cleanpkgforce="sudo paccache -r -k 2" # Actual forced execution purge
alias checktimer="systemctl status paccache.timer paccache.service"
alias update="sudo pacman -Syu"

# dotfiles Git
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


