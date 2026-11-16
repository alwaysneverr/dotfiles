[← README](../README.md)

# Desktop

GTK and Qt setup, keybindings, the bar and launcher icon fixes.

## GTK and Qt

GTK uses adw-gtk3 with colour overrides in `gtk.css`. Qt apps (Dolphin included) use `hyprqt6engine` with the current theme's generated `qt.colors` scheme. These settings aren't stored in files, so run them once:

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
| `Super+T` / `Super+Shift+T` | theme picker (Quickshell / fuzzel fallback) |
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

- **Left:** workspaces, shown as the icons of the apps open on them (an empty workspace shows the theme's icon: a fox for Hsin), then media.
- **Center:** time.
- **Right:** RAM, then one pill with brightness, volume, Wi-Fi, battery and tray (icons only, details on hover), then date and notifications.

| Module | Click | Right click | Other |
|--------|-------|-------------|-------|
| Wi-Fi | network menu (fuzzel) | nmtui | |
| Date | year view | pinned calendar (zenity) | scroll: change month, middle click: today |
| Bell | notification history | do not disturb | |

App icons are mapped by window class in `window-rewrite` (`.config/waybar/config.jsonc`). Unknown apps get a generic icon.

## Launcher icons

hyprtoolkit 0.6.0 has two icon bugs: absolute `Icon=` paths that include a file extension fail ([hyprlauncher#152](https://github.com/hyprwm/hyprlauncher/issues/152)), and icons in `~/.local/share/icons` are missed (fixed upstream in [hyprtoolkit#157](https://github.com/hyprwm/hyprtoolkit/pull/157), not released yet). Fixes used here:

- Copy the app's `.desktop` file to `~/.local/share/applications/` and set `Icon=` to a theme icon name.
- Steam game icons live in `~/.local/share/icons/hicolor`; symlink them into `/usr/share/icons/hicolor` (see the loop in my notes) after adding a game. Not needed once hyprtoolkit 0.6.0 is replaced by a newer release.
- Hide clutter (Wine entries and similar) with `NoDisplay=true` in a local copy.
