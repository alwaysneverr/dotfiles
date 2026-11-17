# Boot theme bases

`theme-boot` builds each theme's boot visuals from these when they're missing on a machine.

- `grub/`: my edited copy of a theme from [vinceliuice/Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes), licensed under GPL-3.0 (`grub/LICENSE`). The background image is removed; every theme brings its own `grub.jpg`.
- `plymouth/`: my own script theme (an emblem fading in and out). `@ID@` and `@NAME@` are filled in per theme; the emblem is the theme's `logo.png`.
