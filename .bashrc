#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

fastfetch

# ====================================================================
# --- HSIN/ASUS M415D CUSTOM HYPRLAND ECOSYSTEM ALIASES ---
# ====================================================================

# 🎨 UI & Theme Config Editors
alias edithypr="nano ~/.config/hypr/hyprland.lua"
alias edittk="nano ~/.config/hypr/hyprtoolkit.conf"
alias editdunst="nano ~/.config/dunst/dunstrc"
alias editwaybar="nano ~/.config/waybar/config.jsonc"
alias editwaybarcss="nano ~/.config/waybar/style.css"

# 🔄 Process Refresh & Component Reloaders
alias reloadlauncher="killall hyprlauncher && hyprlauncher -d"
alias reloaddunst="killall dunst && uwsm app -- dunst &"
alias reloadwaybar="killall waybar && uwsm app -- waybar &"
alias reloadidle="killall hypridle && uwsm app -- hypridle &"
alias reloadall="reloadlauncher && reloaddunst && reloadwaybar && reloadidle"

# 🧪 Desktop Interface Test Generators
alias testnotif="dunstify 'System Synced' 'Connected to Hsin Samba Server node safely.'"
alias testcrit="dunstify -u critical 'Battery Low' 'ASUS power matrix dropping below safe thresholds.'"

# 🧹 System Maintenance & Storage Cleanup
alias cleanpkg="paccache -d -k 2"       # Safe simulation dry-run
alias cleanpkgforce="sudo paccache -r -k 2" # Actual forced execution purge
alias checktimer="systemctl status paccache.timer paccache.service"

# dotfiles Git
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


