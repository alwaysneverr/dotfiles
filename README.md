# dotfiles

Dotfiles for my ASUS M415D laptop: Arch Linux + Hyprland, run through uwsm and themed after Hsin (Wuthering Waves).

Hardware: ASUS VivoBook M415DA, AMD Ryzen 3 3250U, Vega 3 graphics, 14 GB RAM, 1080p panel.

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

## Packages

### 1. Official packages

```sh
sudo pacman -S hyprland uwsm waybar hyprpaper hypridle hyprlock hyprlauncher \
  hyprpolkitagent dunst kitty zsh zsh-autosuggestions zsh-syntax-highlighting \
  grim slurp wl-clipboard jq libnotify brightnessctl playerctl wireplumber \
  pavucontrol bluez blueman power-profiles-daemon mpv dolphin firefox \
  fastfetch ttf-jetbrains-mono-nerd greetd greetd-tuigreet cifs-utils \
  timeshift cronie syncplay steam
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
yay -S vesktop akyuu parsec-bin vita3k-git ttf-orbitron
```

(`paru -S` takes the same arguments.)

| Package | Used for |
|---------|----------|
| `vesktop` | Discord client (autostart, `discord://` links) |
| `akyuu` | anime tracker, a Taiga fork for Linux ([ligneo/akyuu](https://github.com/ligneo/akyuu)) |
| `parsec-bin` | remote desktop |
| `vita3k-git` | PS Vita emulator (fullscreen window rule) |
| `ttf-orbitron` | font |

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
- **Polkit agent:** `hyprpolkitagent` is enabled as a user service (`systemctl --user enable hyprpolkitagent`).
- **Media server:** two CIFS automounts in `/etc/fstab` (`~/M710q/Videos`, `~/M710q/Documents`) over Tailscale, with `vers=3.1.1`. The credentials live in `~/.smbcredentials` (mode 600, not tracked).
- **Wallpaper:** `hsin.jpg` is game artwork, not mine.

Quotes on the lock screen are voice lines from Hsin in Wuthering Waves (© Kuro Games), used for personal customization.

## Launcher icons

hyprlauncher only reads icons from the system folders, and it ignores absolute `Icon=` paths. Fixes used here:

- Copy the app's `.desktop` file to `~/.local/share/applications/` and set `Icon=` to a theme icon name.
- Steam game icons live in `~/.local/share/icons/hicolor`; symlink them into `/usr/share/icons/hicolor` (see the loop in my notes) after adding a game.
- Hide clutter (Wine entries and similar) with `NoDisplay=true` in a local copy.
