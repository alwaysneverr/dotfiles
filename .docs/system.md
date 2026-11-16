[← README](../README.md)

# System-level notes

Changes outside `$HOME`, so not in this repo.

## System-level notes (outside this repo)

- **greetd:** `/etc/greetd/config.toml` runs `tuigreet` with `--remember --remember-session`, the session list from `/usr/share/wayland-sessions`, a matrix background, and colours that `theme-boot` sets per theme. Logging in through uwsm is what makes autostart apps start. Sessions start through `/usr/local/bin/quiet-session` (tuigreet `--session-wrapper`), which sends uwsm's startup output to `~/.local/state/session-start.log` instead of the screen.
- **Snapshots:** Timeshift (rsync) on the root partition, `/home` excluded. `/boot` is a separate FAT partition, so a pacman hook (`95-bootbackup.hook`) copies it to `/.bootbackup` on every kernel change, and Timeshift picks that up.
- **Cleanup routine:** `paccache.timer` is enabled, plus `fstrim.timer` and `reflector` for mirrors.
- **Polkit agent:** `hyprpolkitagent` is enabled as a user service (`systemctl --user enable hyprpolkitagent`).
- **Media server:** two CIFS automounts in `/etc/fstab` (`~/M710q/Videos`, `~/M710q/Documents`) over Tailscale, with `vers=3.1.1`. The credentials live in `~/.smbcredentials` (mode 600, not tracked).
- **GRUB:** Wuthering-hsin theme in `/boot/grub/themes/Wuthering-hsin` (copied from my E420; based on [vinceliuice/Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes), edited by me). `theme-boot` copies it as `Wuthering-<theme>` with the theme's `grub.jpg`. In `/etc/default/grub`: `GRUB_THEME` points at its `theme.txt`, `GRUB_GFXMODE=1920x1080,auto`, and `GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 rd.udev.log_level=3 udev.log_level=3 vt.global_cursor_default=0 splash"` for a quiet boot. Rebuild with `grub-update` (not `grub-mkconfig`), which also strips the "Loading…" lines.
- **Watchdog:** `sp5100_tco` is blacklisted (`/etc/modprobe.d/no-watchdog.conf`) to silence "watchdog did not stop" at shutdown.
- **Plymouth:** custom script theme (the emblem fading in and out on black), installed in `/usr/share/plymouth/themes/hsin`; `theme-boot` copies it per theme with that theme's `logo.png`. A copy is kept in `.local/share/plymouth-themes/hsin`. Set up with: the `plymouth` hook after `systemd` in `/etc/mkinitcpio.conf` (with `kms` for early graphics), `splash` in the kernel options, and `/etc/systemd/system/greetd.service.d/plymouth.conf` (`After=plymouth-quit.service plymouth-quit-wait.service`) so the greeter waits for the splash. After editing the theme, run `sudo mkinitcpio -P`.
- **Theme switcher:** `/usr/local/bin/theme-boot` (root, via pkexec) switches GRUB, Plymouth and tuigreet for `theme-switch NAME --boot`. A copy is kept in `.config/themes/theme-boot`.
- **logind:** `/etc/systemd/logind.conf.d/lock-delay.conf` sets `InhibitDelayMaxSec=10`, so hypridle can hold suspend until the lock screen is up.
