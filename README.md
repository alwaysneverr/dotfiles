# dotfiles

Dotfiles for my ASUS M415D laptop: Arch Linux + Hyprland, run through uwsm and themed after Hsin (Wuthering Waves).

## Stack

| Part | Choice |
|------|--------|
| OS | Arch Linux (systemd) |
| Compositor | Hyprland (Lua config), launched through uwsm |
| Login | greetd + tuigreet (matrix background) |
| Launcher | hyprlauncher (custom Hsin stylesheet) |
| Bar | Waybar |
| Terminal | kitty |
| Notifications | dunst |
| Lock and idle | hyprlock + hypridle |
| Wallpaper | hyprpaper |
| Screenshots | grim + slurp (`hypr/screenshot.sh`) |
| Files | Dolphin |
| Shell | zsh (bash as fallback) |
| Video | mpv with uosc and videoclip |
| Snapshots | Timeshift (rsync, daily) |

## Palette

The launcher uses amber `#f4a261`, crimson `#d62828` and a dark translucent ink background `rgba(18, 19, 38, 0.85)`.

## Layout

This is a bare repo whose work tree is `$HOME`.

```sh
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
config status
config add <file>
config commit -m "..."
config push
```

Untracked files are hidden (`status.showUntrackedFiles no`), so new configs have to be added by hand.

## Install on a new machine

```sh
git clone --bare git@github.com:alwaysneverr/dotfiles.git $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
config checkout
config config status.showUntrackedFiles no
```

If checkout complains about existing files, move them aside and retry.

## What's tracked

| Path | What it is |
|------|------------|
| `.config/hypr/hyprland.lua` | Hyprland config (Lua): autostart, binds, window rules, animations |
| `.config/hypr/hypridle.conf` | idle actions: dim, power saver, lock, suspend |
| `.config/hypr/hyprlock.conf` | lock screen |
| `.config/hypr/hyprpaper.conf` | wallpaper |
| `.config/hypr/hyprtoolkit.conf` | shared theme for Hypr apps |
| `.config/hypr/screenshot.sh` | screenshot script (grim + slurp, with notification) |
| `.config/hyprlauncher/style.css` | launcher theme |
| `.config/waybar/` | bar config and style |
| `.config/dunst/dunstrc` | notifications |
| `.config/kitty/kitty.conf` | terminal |
| `.config/fastfetch/config.jsonc` | system info |
| `.config/uwsm/env` | session environment (DPI scaling) |
| `.config/mpv/` | `mpv.conf`, `input.conf`, `script-opts/` |
| `.config/mimeapps.list` | default applications |
| `.zshrc`, `.bashrc` | shell config, aliases, prompt |
| `Pictures/Wallpapers/hsin.jpg` | wallpaper |

mpv scripts (`uosc`, `videoclip`) and fonts are not tracked. Reinstall them by hand.

## System-level notes (outside this repo)

- **greetd:** `/etc/greetd/config.toml` runs `tuigreet` with `--remember --remember-session`, the session list from `/usr/share/wayland-sessions`, a yellow/gold theme and a matrix background. Logging in through uwsm is what makes autostart apps start.
- **Snapshots:** Timeshift (rsync) on the root partition, `/home` excluded. `/boot` is a separate FAT partition, so a pacman hook (`95-bootbackup.hook`) copies it to `/.bootbackup` on every kernel change, and Timeshift picks that up.
- **Cleanup routine:** `paccache.timer` is enabled, plus `fstrim.timer` and `reflector` for mirrors.
