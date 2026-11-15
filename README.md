# dotfiles

Dotfiles for my ASUS M415D laptop: Arch Linux + Hyprland, run through uwsm and themed after Hsin (Wuthering Waves).

Hardware: ASUS VivoBook M415DA, AMD Ryzen 3 3250U, Vega 3 graphics, 14 GB RAM, 1080p panel.

## Stack

| Part | Choice |
|------|--------|
| OS | Arch Linux (systemd) |
| Bootloader | GRUB, Wuthering-hsin theme, quiet boot |
| Compositor | Hyprland (Lua config), launched through uwsm |
| Login | greetd + tuigreet (matrix background) |
| Launcher | hyprlauncher (custom Hsin stylesheet) |
| Bar | Waybar (app icons per workspace, icon-only status pill) |
| Terminal | kitty |
| Notifications | dunst |
| Lock and idle | hyprlock + hypridle |
| Wallpaper | hyprpaper |
| Screenshots | grim + slurp (`hypr/screenshot.sh`) |
| Menus | fuzzel (Wi-Fi, power, clipboard, notification history, dunst actions) |
| Clipboard | cliphist |
| Files | Dolphin |
| Theming | adw-gtk3 (GTK), hyprqt6engine + `Hsin.colors` (Qt) |
| Images | imv (`imv-folder` wrapper) |
| Shell | zsh (bash as fallback) |
| Video | mpv with uosc and videoclip |
| Snapshots | Timeshift (rsync, daily) |

## Palette

The launcher, dunst, GTK and Qt use amber `#f4a261`, crimson `#d62828` and a dark translucent ink background `rgba(18, 19, 38, 0.85)`.

## Theming

GTK uses adw-gtk3 with colour overrides in `gtk.css`. Qt apps (Dolphin included) use `hyprqt6engine` with the `Hsin.colors` scheme. These settings aren't stored in files, so run them once:

```sh
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'orange'
gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
```

`imv-folder.desktop` has my home path hardcoded; edit it on another machine.

## Keybindings

`Super` is the main modifier.

| Keys | Action |
|------|--------|
| `Super+Q` | terminal (kitty) |
| `Super+E` | file manager (Dolphin) |
| `Super+R` | launcher (hyprlauncher) |
| `Super+Shift+F` | Firefox |
| `Super+C` | close window |
| `Super+V` / `Super+P` / `Super+J` | float / pseudo / toggle split |
| `Super+L` | lock screen |
| `Super+M` | log out (`uwsm stop`) |
| `Super+1..0` / `Super+Shift+1..0` | go to / move window to workspace |
| `Super+S` | scratchpad workspace |
| `Super+arrows` | move focus |
| `Print` / `Super+Print` / `Super+X` | screenshot: region / full / window |
| `Super+Alt+S` | Syncplay |
| `Super+Shift+V` | media server folder (Dolphin) |
| `Super+Alt+V` | clipboard history |
| `Super+N` | notification history (also: click the bell in Waybar; right-click toggles do not disturb) |
| `Fn+F11` | region screenshot (the key sends `Super+Shift+S`) |
| `Fn+F12` (MyASUS key) | power menu: lock, log out, suspend, reboot, shut down |
| touchpad key | toggle the touchpad |

## Bar

- **Left:** workspaces, shown as the icons of the apps open on them (an empty workspace shows a fox), then media.
- **Center:** time.
- **Right:** RAM, then one pill with brightness, volume, Wi-Fi, battery and tray (icons only, details on hover), then date and notifications.

| Module | Click | Right click | Other |
|--------|-------|-------------|-------|
| Wi-Fi | network menu (fuzzel) | nmtui | |
| Date | year view | pinned calendar (zenity) | scroll: change month, middle click: today |
| Bell | notification history | do not disturb | |

App icons are mapped by window class in `window-rewrite` (`.config/waybar/config.jsonc`). Unknown apps get a generic icon.

## Packages

### 1. Official packages

```sh
sudo pacman -S hyprland uwsm waybar hyprpaper hypridle hyprlock hyprlauncher \
  hyprpolkitagent dunst kitty zsh zsh-autosuggestions zsh-syntax-highlighting \
  grim slurp wl-clipboard jq libnotify brightnessctl playerctl wireplumber \
  pavucontrol bluez blueman power-profiles-daemon mpv dolphin firefox \
  fastfetch ttf-jetbrains-mono-nerd greetd greetd-tuigreet cifs-utils \
  timeshift cronie syncplay steam adw-gtk-theme breeze imv fuzzel cliphist zenity
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
yay -S vesktop akyuu parsec-bin vita3k-git ttf-orbitron hyprqt6engine
```

(`paru -S` takes the same arguments.)

| Package | Used for |
|---------|----------|
| `vesktop` | Discord client (autostart, `discord://` links) |
| `akyuu` | anime tracker, a Taiga fork for Linux ([ligneo/akyuu](https://github.com/ligneo/akyuu)) |
| `parsec-bin` | remote desktop |
| `vita3k-git` | PS Vita emulator (fullscreen window rule) |
| `ttf-orbitron` | font (lock screen clock) |
| `hyprqt6engine` | Qt theme engine (Dolphin and other Qt apps follow `Hsin.colors`) |

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
| `.config/waybar/` | bar config and style (see Bar) |
| `.local/bin/wifi-menu` | Wi-Fi picker (nmcli + fuzzel) |
| `.config/fuzzel/fuzzel.ini` | menu theme |
| `.local/bin/power-menu` | power menu (fuzzel) |
| `.local/bin/clip-menu` | clipboard history picker (cliphist + fuzzel) |
| `.local/bin/notif-center`, `.local/bin/notif-status` | notification history picker and Waybar bell |
| `.local/bin/touchpad-toggle` | touchpad on/off (`hyprctl eval hl.device`) |
| `.local/bin/grub-update` | rebuild `grub.cfg` without the "Loading…" lines |
| `.config/dunst/dunstrc` | notifications |
| `.config/kitty/kitty.conf` | terminal |
| `.config/fastfetch/config.jsonc` | system info |
| `.config/uwsm/env` | session environment (DPI scaling, Qt theme) |
| `.config/mpv/` | `mpv.conf`, `input.conf`, `script-opts/` |
| `.config/mimeapps.list` | default applications |
| `.config/gtk-3.0/gtk.css`, `.config/gtk-4.0/gtk.css` | GTK colour overrides |
| `.config/hypr/hyprqt6engine.conf` | Qt theme (colour scheme, icons, style) |
| `.local/share/color-schemes/Hsin.colors` | KDE/Qt colour scheme |
| `.config/imv/config` | image viewer colours |
| `.local/bin/imv-folder`, `.local/share/applications/imv-folder.desktop` | opens an image with its whole folder loaded |
| `.zshrc`, `.bashrc` | shell config, aliases, prompt |
| `Pictures/Wallpapers/hsin.jpg` | wallpaper |

mpv scripts (`uosc`, `videoclip`) and fonts are not tracked. Reinstall them by hand.

## System-level notes (outside this repo)

- **greetd:** `/etc/greetd/config.toml` runs `tuigreet` with `--remember --remember-session`, the session list from `/usr/share/wayland-sessions`, a yellow/gold theme and a matrix background. Logging in through uwsm is what makes autostart apps start.
- **Snapshots:** Timeshift (rsync) on the root partition, `/home` excluded. `/boot` is a separate FAT partition, so a pacman hook (`95-bootbackup.hook`) copies it to `/.bootbackup` on every kernel change, and Timeshift picks that up.
- **Cleanup routine:** `paccache.timer` is enabled, plus `fstrim.timer` and `reflector` for mirrors.
- **Polkit agent:** `hyprpolkitagent` is enabled as a user service (`systemctl --user enable hyprpolkitagent`).
- **Media server:** two CIFS automounts in `/etc/fstab` (`~/M710q/Videos`, `~/M710q/Documents`) over Tailscale, with `vers=3.1.1`. The credentials live in `~/.smbcredentials` (mode 600, not tracked).
- **GRUB:** Wuthering-hsin theme in `/boot/grub/themes/Wuthering-hsin` (copied from my E420; based on [vinceliuice/Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes), edited by me). In `/etc/default/grub`: `GRUB_THEME` points at its `theme.txt`, `GRUB_GFXMODE=1920x1080,auto`, and `GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 rd.udev.log_level=3 udev.log_level=3 vt.global_cursor_default=0"` for a quiet boot. Rebuild with `grub-update` (not `grub-mkconfig`), which also strips the "Loading…" lines.
- **Wallpaper:** `hsin.jpg` is game artwork, not mine.

Quotes on the lock screen are voice lines from Hsin in Wuthering Waves (© Kuro Games), used for personal customization.

## Launcher icons

hyprtoolkit 0.6.0 has two icon bugs: absolute `Icon=` paths that include a file extension fail ([hyprlauncher#152](https://github.com/hyprwm/hyprlauncher/issues/152)), and icons in `~/.local/share/icons` are missed (fixed upstream in [hyprtoolkit#157](https://github.com/hyprwm/hyprtoolkit/pull/157), not released yet). Fixes used here:

- Copy the app's `.desktop` file to `~/.local/share/applications/` and set `Icon=` to a theme icon name.
- Steam game icons live in `~/.local/share/icons/hicolor`; symlink them into `/usr/share/icons/hicolor` (see the loop in my notes) after adding a game. Not needed once hyprtoolkit 0.6.0 is replaced by a newer release.
- Hide clutter (Wine entries and similar) with `NoDisplay=true` in a local copy.
