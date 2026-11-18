# dotfiles

Dotfiles for my ASUS M415D laptop: Arch Linux + Hyprland, run through uwsm and themed after Wuthering Waves, with switchable desktop themes (Hsin, Shorekeeper, Aemeath and Reze).

Hardware: ASUS VivoBook M415DA, AMD Ryzen 3 3250U, Vega 3 graphics, 14 GB RAM, 1080p panel.

## Preview

Shown: **Shorekeeper**. Every theme: [theme gallery](.docs/gallery.md).

**Wallpaper**

![Shorekeeper wallpaper](.config/themes/shorekeeper/wallpaper.jpg)

**Lock screen**

![Lock screen](Pictures/readme/lock-shorekeeper.png)

**Lock background**

![Lock background loop](Pictures/readme/lock-bg-shorekeeper.webp)

**Boot menu (GRUB)**

![GRUB](Pictures/readme/grub-shorekeeper.png)

**Boot splash (Plymouth)**

![Plymouth](Pictures/readme/plymouth-shorekeeper.gif)

## At a glance

- **Hyprland** (Lua config) through **uwsm**, autologin with **greetd** that boots straight into the lock screen
- **Switchable themes** (Hsin, Shorekeeper, Aemeath, Reze): one command or `Super+T` recolours the desktop, lock screen, shell and fastfetch, and optionally GRUB, Plymouth and the greeter
- **Animated wallpapers:** video (mpvpaper) or GIF (awww) per theme, with a transition on every switch; `Super+Shift+W` toggles to the still image
- **Quickshell** lock screen (qylock) and theme picker, **Waybar** with app icons per workspace, **fuzzel** menus for Wi-Fi, power, clipboard and notifications
- Quiet boot: themed GRUB, Plymouth splash, no console text

## Docs

| Doc | What's in it |
|-----|--------------|
| [Stack](.docs/stack.md) | every part and the packages behind it |
| [Themes](.docs/themes.md) | switching, how it works, options, adding a theme, palettes |
| [Gallery](.docs/gallery.md) | every theme compared: palettes, wallpapers, lock screens, boot visuals |
| [Desktop](.docs/desktop.md) | GTK/Qt setup, keybindings, bar, launcher icon fixes |
| [Lock screen](.docs/lock-screen.md) | qylock setup, how locking works, recovery |
| [Install](.docs/install.md) | packages, bare repo layout, new machine, what's tracked |
| [System notes](.docs/system.md) | greetd, GRUB, Plymouth, logind and other changes outside `$HOME` |

## Quick start

```sh
git clone --bare git@github.com:alwaysneverr/dotfiles.git $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
config checkout && config config status.showUntrackedFiles no
theme-switch hsin
```

Install the packages first and see [Install](.docs/install.md) for the full steps.

## Credits

- **Hsin**, **Shorekeeper**, **Aemeath** and all Wuthering Waves material belong to Kuro Games, used here for personal customization:
  - the Hsin wallpaper;
  - the lock screen background, a loop cut from the Hsin trailer;
  - the voice-line quotes on the hyprlock fallback (both characters);
  - the Mengzhou emblem (the fox logo);
  - the Shorekeeper wallpaper (Tethys) and the Black Shores emblem;
  - the Shorekeeper lock screen background, a loop cut from her trailer;
  - the Aemeath wallpaper, splash art (GRUB background) and emblem, and her lock screen loop, cut from her trailer.
- **Reze** (Chainsaw Man) belongs to Tatsuki Fujimoto / Shueisha, used here for personal customization: the lock screen loop is cut from the MAPPA anime, and the animated "Last Summer" wallpaper is fan art found on vsthemes.org. The sparkler emblem is my own.
- **Lock screen:** based on the Wuthering Waves theme from [qylock](https://github.com/Darkkal44/qylock) by Darkkal44 (recoloured and edited by me), with its Orbitron font.
- **GRUB theme:** based on [Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes) by vinceliuice, edited by me.
