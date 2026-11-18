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

alias fastfetch='clear && fastfetch -c "$HOME/.config/themes/current/gen/fastfetch.jsonc"'

# Faster Directory Traversal
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'            # Creates parent directories if missing and prints confirmation

alias rm='rm -i'      # Ask for confirmation before destroying any file
alias cp='cp -i'      # Prompt before overwriting a file during copy
alias mv='mv -i'      # Prompt before overwriting a file during a move

# ====================================================================
# --- PROMPT (colours from the active theme) ---
# ====================================================================

# Colours come from the active theme (theme-switch), re-read before every prompt
_theme_prompt() {
    [ -r "$HOME/.config/themes/current/gen/prompt.sh" ] && . "$HOME/.config/themes/current/gen/prompt.sh"
    _c() { printf '\\[\\033[38;2;%d;%d;%dm\\]' "0x${1:1:2}" "0x${1:3:2}" "0x${1:5:2}"; }
    PS1="$(_c "$THEME_DIM")[$(_c "$THEME_USER")\u$(_c "$THEME_AT")@$(_c "$THEME_USER")\h$(_c "$THEME_DIM")] $(_c "$THEME_PATH")\w $(_c "$THEME_ARROW")❯\[\033[0m\] "
}
PROMPT_COMMAND="_theme_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

fastfetch

alias hlog="uwsm stop"
alias hcheck="uwsm check may-start"

alias ff="uwsm app -- firefox"
alias fm="uwsm app -- dolphin"
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

alias cleanpkg="paccache -d -k 2"       # Safe simulation dry-run
alias cleanpkgforce="sudo paccache -r -k 2" # Actual forced execution purge
alias checktimer="systemctl status paccache.timer paccache.service"
alias update="sudo pacman -Syu"

# dotfiles Git
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias server="uwsm app -- dolphin ~/M710q/Videos"
