[← README](../README.md)

# Install

Packages, how the bare repo works, and what it tracks.

## Packages

### 1. Official packages

```sh
sudo pacman -S hyprland uwsm waybar awww hypridle hyprlock hyprlauncher \
  hyprpolkitagent dunst kitty zsh zsh-autosuggestions zsh-syntax-highlighting \
  grim slurp wl-clipboard jq libnotify brightnessctl playerctl wireplumber \
  pavucontrol bluez blueman power-profiles-daemon mpv dolphin firefox \
  fastfetch ttf-jetbrains-mono-nerd greetd greetd-tuigreet cifs-utils \
  timeshift cronie syncplay steam adw-gtk-theme breeze imv fuzzel cliphist zenity plymouth python
```

`steam` needs the `multilib` repo enabled in `/etc/pacman.conf`.

### 2. An AUR helper

The AUR packages below need a helper. I use [`yay`](https://github.com/Jguer/yay); [`paru`](https://github.com/Morganamilo/paru) works the same way. Both are built by hand once, then manage everything else:

```sh
sudo pacman -S --needed git base-devel

# yay
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin && makepkg -si

# or paru
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin && makepkg -si
```

### 3. AUR packages

```sh
yay -S vesktop akyuu parsec-bin vita3k-git ttf-orbitron hyprqt6engine quickshell
```

(`paru -S` takes the same arguments.)

| Package | Used for |
|---------|----------|
| `vesktop` | Discord client (autostart, `discord://` links) |
| `akyuu` | anime tracker, a Taiga fork for Linux ([ligneo/akyuu](https://github.com/ligneo/akyuu)) |
| `parsec-bin` | remote desktop |
| `vita3k-git` | PS Vita emulator (fullscreen window rule) |
| `ttf-orbitron` | font (lock screen clock, theme picker) |
| `quickshell` | lock screen and theme picker |
| `hyprqt6engine` | Qt theme engine (Dolphin and other Qt apps follow the theme's `qt.colors`) |

The mpv scripts `uosc` and `videoclip` are installed by hand.

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
sudo install -m 755 ~/.config/themes/theme-boot /usr/local/bin/
theme-switch hsin
```

`theme-switch` builds the generated files that aren't tracked (`gen/`, `current`, the lock theme folders).

If checkout complains about existing files, move them aside and retry.

## What's tracked

| Path | What it is |
|------|------------|
| `.config/hypr/hyprland.lua` | Hyprland config (Lua): autostart, binds, window rules, animations |
| `.config/hypr/hypridle.conf` | idle actions: dim, power saver, lock, suspend |
| `.config/hypr/hyprlock.conf` | lock screen |
| `.local/bin/wallpaper-set` | sets the wallpaper through awww, with a transition |
| `.config/hypr/hyprtoolkit.conf` | shared theme for Hypr apps (link to the theme's generated file) |
| `.config/hypr/screenshot.sh` | screenshot script (grim + slurp, with notification) |
| `.config/hyprlauncher/style.css` | launcher theme |
| `.config/waybar/` | bar config and style (see [Bar](desktop.md#bar)) |
| `.local/bin/wifi-menu` | Wi-Fi picker (nmcli + fuzzel) |
| `.config/fuzzel/fuzzel.ini` | menu theme |
| `.local/bin/power-menu` | power menu (fuzzel) |
| `.local/bin/clip-menu` | clipboard history picker (cliphist + fuzzel) |
| `.local/bin/notif-center`, `.local/bin/notif-status` | notification history picker and Waybar bell |
| `.local/bin/touchpad-toggle` | touchpad on/off (`hyprctl eval hl.device`) |
| `.local/bin/grub-update` | rebuild `grub.cfg` without the "Loading…" lines |
| `.config/themes/` | themes: `theme.ini`, wallpaper, emblem, lock video, GRUB image, quotes; `_base/` boot theme bases; copy of `theme-boot` |
| `.local/bin/theme-*` | `theme-gen`, `theme-switch`, `theme-list`, pickers, one-time migration scripts |
| `.config/quickshell/theme-picker/` | Quickshell theme picker |
| `.local/share/qylock-themes/_shared/` | shared lock screen QML and font |
| `.config/dunst/dunstrc`, `.config/dunst/dunstrc.d/` | notifications (theme colours via `dunstrc.d`) |
| `.config/kitty/kitty.conf` | terminal |
| `.config/fastfetch/config.jsonc` | system info |
| `.config/uwsm/env` | session environment (DPI scaling, Qt theme) |
| `.config/mpv/` | `mpv.conf`, `input.conf`, `script-opts/` |
| `.config/mimeapps.list` | default applications |
| `.config/gtk-3.0/gtk.css`, `.config/gtk-4.0/gtk.css` | GTK colour overrides |
| `.config/hypr/hyprqt6engine.conf` | Qt theme (colour scheme, icons, style) |
| `.config/imv/config` | image viewer colours |
| `.local/bin/imv-folder`, `.local/share/applications/imv-folder.desktop` | opens an image with its whole folder loaded |
| `.zshrc`, `.bashrc` | shell config, aliases, prompt |

mpv scripts (`uosc`, `videoclip`) and fonts are not tracked. Reinstall them by hand.
