[← README](../README.md)

# Stack

## Core

| Part | Packages | Notes |
|------|----------|-------|
| OS | `linux`, `linux-lts` | Arch Linux, systemd |
| Bootloader | `grub` | Wuthering theme per desktop theme, quiet boot (`grub-update`) |
| Boot splash | `plymouth` | the theme's emblem fading in and out |
| Login | `greetd`, `greetd-tuigreet` | matrix background in theme colours; session output goes to a log (`quiet-session`) |
| Session | `uwsm` | starts Hyprland and autostart apps as systemd units |
| Compositor | `hyprland` | Lua config |
| Bar | `waybar` | app icons per workspace, icon-only status pill |
| Launcher | `hyprlauncher` | follows the theme |
| Notifications | `dunst` | click opens the app; history on `Super+N` |
| Lock and idle | `quickshell`, `hypridle`, `hyprlock` | qylock with one theme per desktop theme; hyprlock as fallback |
| Wallpaper | `awww`, `mpvpaper` | awww: stills, GIFs and transitions; mpvpaper: video wallpapers (`wallpaper-set`) |
| Polkit | `hyprpolkitagent` | user service |
| Terminal | `kitty` | |
| Shell | `zsh`, `zsh-autosuggestions`, `zsh-syntax-highlighting` | bash as fallback |
| Theming | `adw-gtk-theme`, `breeze`, `hyprqt6engine` | current theme's palette for GTK and Qt |
| Theme switcher | `python`, `quickshell` | `theme-switch`, picker on `Super+T` (see [Themes](themes.md)) |
| Audio | `pipewire`, `wireplumber` | |
| Network | `networkmanager` | |

## Utilities

| Part | Packages | Notes |
|------|----------|-------|
| Files | `dolphin` | |
| Menus | `fuzzel` | Wi-Fi, power, clipboard, notification history |
| Clipboard | `cliphist`, `wl-clipboard` | |
| Screenshots | `grim`, `slurp` | `hypr/screenshot.sh` |
| Images | `imv` | `imv-folder` opens the whole folder |
| Video | `mpv` | uosc and videoclip, installed by hand |
| Calendar | `quickshell` | popup calendar on right-click of the date (`calendar-qs`) |
| OSD | `quickshell` | volume, mic and brightness pop-up (`qs -c osd`) |
| Bluetooth | `bluez`, `blueman` | |
| Hardware keys | `brightnessctl`, `playerctl` | |
| Snapshots | `timeshift`, `cronie` | rsync, daily |
| Media server | `cifs-utils`, `tailscale` | CIFS automounts |
| System info | `fastfetch` | |
