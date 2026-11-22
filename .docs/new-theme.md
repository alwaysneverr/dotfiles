[← Themes](themes.md)

# Making a new theme

From nothing to a full theme: desktop, lock screen, terminal, login screen (tuigreet), boot menu (GRUB) and boot splash (Plymouth). `theme-new` and `theme-import` handle the setup and the file conversion. You supply the art and the character's lines.

The examples use a theme with the ID `ghost`. IDs use `a-z`, `0-9` and `-`.

## 1. Gather the material

| What | Used for | Notes |
|---|---|---|
| Wallpaper | Desktop, palette, still lock screen | 16:9, 1920×1080 or larger. A GIF or video makes an animated wallpaper. |
| Emblem | Lock screen, picker, Plymouth, Waybar's empty-workspace icon (as a glyph) | Square, transparent background. Draw your own if the official one is a trademark you'd rather not ship. |
| Lock clip | Video lock screen | A few seconds without camera movement loops best. A still image works too. |
| GRUB art | Boot menu background | Boot themes only. Keep space free for the menu. |
| Quotes | Terminal greeting | One per line, from the character. |
| Tagline, fail text | Lock screen | One line each, from the character. |
| Credits | README, gallery | Who drew each piece, with a link. |

If you may not publish an image (the artist asked for no reuploads, or it's risqué), plan to keep it out of git from the start (step 8).

## 2. Create the theme

```
theme-new ghost "Ghost" --wallpaper ~/Downloads/ghost.jpg --layout novel
```

| Option | Effect |
|---|---|
| `--wallpaper FILE` | Imports the wallpaper and derives the whole palette from it: colours, ANSI, lock colours, tuigreet colours |
| `--layout wuwa\|stage\|novel` | Lock layout: `wuwa` for a full-screen video with the clock on the side, `stage` for the clip in a framed window, `novel` for full-screen art with the text centred like lines on a page |
| `--boot` | Also sets up GRUB and Plymouth (sets `grub_theme` and `plymouth_theme` to the ID). Without it the theme is desktop-only (`boot = no`) |
| `--accent HEX`, `--secondary HEX` | Pins those colours and builds everything else around them |
| `--from THEME` | The theme whose `theme.ini` is the template (default `shorekeeper`) |

The palette guess is good on vivid art. On pale art it can land on skin tones and give a muddy brown bar. In that case, pin the character's own colours (eyes, hair, outfit) and redo the palette; nothing else changes:

```
theme-new ghost --repalette --accent '#e0709a' --secondary '#ead39c'
```

New themes start with `gallery = no`, so they stay out of the gallery until you're done.

## 3. Import the media

`theme-import ID KIND FILE` converts each file to what the switcher expects:

```
theme-import ghost logo ~/Downloads/emblem.png
theme-import ghost lock ~/Downloads/episode.mkv --from 1:48 --to 1:50 --pingpong
theme-import ghost quotes ~/Downloads/ghost-quotes.txt
```

| Kind | Writes | Notes |
|---|---|---|
| `wallpaper` | `wallpaper.jpg`; GIF also `wallpaper.gif`, video also `wallpaper.mp4` | The animated one wins; `Super+Shift+W` toggles the still |
| `lock` | Video → `lock.mp4`; image → `lock.jpg` | `--from`/`--to` (seconds or `mm:ss`), `--speed 1.6`, `--pingpong` (forwards then backwards, a seamless loop), `--size 1440x810` (default 1920×1080). Without either file, the lock screen uses the wallpaper |
| `logo` | `logo.png` | 256 px square, transparent padding |
| `backdrop` | `lock-backdrop.jpg` | Blurred and darkened, behind the `stage` frame. From a video, `--from` picks the frame |
| `grub` | `grub.jpg` | 1920×1080 cover crop, baseline JPEG (GRUB can't read progressive JPEGs) |
| `quotes` | `quotes.txt` | Drops blank lines and duplicates |

Still images are rotated according to their EXIF data when ImageMagick is installed.

## 4. Fill in `theme.ini`

`theme-new` writes the palette. These need you:

```ini
[meta]
name = Ghost
# series name, shown in the gallery
source = 9-nine-
# a Nerd Font glyph for empty workspaces in Waybar
workspace_empty_icon = 󰊠

[lock]
# a line from the character, and the one shown after a wrong password
tagline = ...
failtext = ...
footer = Ghost  ·  9-nine- (PALETTE)
```

Put comments on their own lines: a `#` after a value becomes part of the value.

Find glyphs on the [Nerd Fonts cheat sheet](https://www.nerdfonts.com/cheat-sheet) (search the character's motif: ghost, star, pen, fox…).

Optional settings:

| Where | Setting | Effect |
|---|---|---|
| `[lock]` | `ink`, `serif`, `sans` | `novel` layout: text colour and fonts |
| `[lock]` | `vignette = 0.3` | `novel` layout: lighter edge darkening for pale art (default 0.62) |
| `[meta]` | `plymouth_style = spin` | Rotating, twinkling emblem instead of the default fade |
| `[meta]` | `grub_logo = none` | No emblem on the GRUB screen |
| `[meta]` | `tuigreet_theme`, `tuigreet_matrix` | Login colours. Only named terminal colours work (`red`, `lightmagenta`, `gray`…); `theme-new` picks them from the accent's hue |

## 5. Try it on the desktop

```
theme-switch ghost
```

Or press `Super+T`: new themes appear in the picker on their own. To see the lock screen, lock the session. Repeat steps 2–4 until it looks right.

## 6. Boot visuals: GRUB, Plymouth, tuigreet

Skip this step for a desktop-only theme. To turn an existing desktop-only theme into a boot theme, delete `boot = no` and add `grub_theme = ghost` and `plymouth_theme = ghost` under `[meta]`.

1. `theme-import ghost grub FILE` for the GRUB background.
2. Optional: `plymouth-bg.png` (1920×1080) in the theme folder, for a background behind the Plymouth emblem; `grub-logo.png`, for a different emblem in GRUB than on the lock screen.
3. Apply:
   ```
   theme-switch ghost --boot
   ```
   It asks for your password and takes about 30 seconds. `theme-boot` then:
   - **Plymouth:** builds the theme from `_base/plymouth` with the chosen style and `logo.png`, rebuilt on every run, then runs `mkinitcpio -P`.
   - **GRUB:** copies `_base/grub` to `/boot/grub/themes/ghost` the first time, swaps in `grub.jpg` and the emblem, then runs `grub-mkconfig`. To pick up later changes to `_base/grub`, delete that folder and run it again.
   - **tuigreet:** writes the colours into `/etc/greetd/config.toml`.
4. Preview GRUB without rebooting:
   ```
   grub2-theme-preview /boot/grub/themes/ghost
   ```

### A custom GRUB layout

To go beyond the base theme (like Han Sooyoung's frosted panel on the left), make a `grub-theme/` folder in the theme with your own `theme.txt` and pixmaps. `theme-boot` copies it over the base on every run. `grub.jpg` replaces the image named in `desktop-image`.

- **Fonts:** GRUB uses `.pf2` fonts. Make them with `grub-mkfont -n "NAME" -s SIZE -o FILE.pf2 FONT.ttf`; `theme.txt` then refers to `NAME Regular SIZE` or `NAME Bold SIZE`. GRUB loads every `.pf2` in the folder.
- **No anti-aliasing:** GRUB draws text without smoothing. A well-hinted sans (Noto Sans, DejaVu Sans) at 20 px or more looks smooth; serifs come out jagged.
- **zsh:** in a script, write `"${1}:weight=bold"`, not `"$1:weight=bold"`: zsh reads `$1:w` as a modifier and silently mangles the font name.
- **Scrolling:** with `scrollbar = true`, GRUB draws the scrollbar only when the entries don't fit.
- Generated `.pf2` files can be rebuilt, so `.gitignore` can leave them out.

## 7. Gallery and README

1. Previews: `Pictures/readme/lock-ghost.png`, `grub-ghost.png` and `plymouth-ghost.gif`. Take the screenshots and recording yourself; `grub2-theme-preview` helps with GRUB. `theme-gallery` makes the palette swatch and the looping lock preview (from `lock.mp4`) on its own.
2. In `[meta]`: delete `gallery = no`. If the art can't be shown, add `publish = no` and `art_link = <artist's page>`; the gallery then shows only a credit note, the emblem and the Plymouth preview.
3. Run `theme-gallery`.
4. Add the theme to the README: the theme list in the intro and "At a glance", and the credits (official art vs fan art, with links).

## 8. Commit

Keep out of git anything you may not publish, before the first `config add`. In `~/.config/themes/.gitignore`:

```
ghost/wallpaper.*
ghost/lock.*
```

Do the same for previews in `Pictures/readme/.gitignore`. Then:

```
config add .config/themes/ghost Pictures/readme/*ghost* .docs/gallery.md README.md
config status --short          # check that nothing ignored slipped in
config commit -m "Ghost theme" && config push
```

If an image slips into a commit anyway, removing it in a later commit isn't enough: the history has to be rewritten with `git filter-repo --invert-paths`, as was done for Han Sooyoung.

## Checklist

| | Desktop-only | Boot theme |
|---|---|---|
| `theme-new` (with `--wallpaper`) | ✓ | ✓ with `--boot` |
| Emblem (`logo`) | ✓ | ✓ |
| Lock clip or image (`lock`), `backdrop` for `stage` | ✓ | ✓ |
| Quotes, tagline, fail text, footer, `source`, workspace icon | ✓ | ✓ |
| `grub.jpg` (`grub`) | | ✓ |
| `theme-switch ID --boot`, GRUB preview | | ✓ |
| `.gitignore` for unpublishable art | ✓ | ✓ |
| Gallery previews, `theme-gallery`, README credits | ✓ | ✓ |

## Not automated yet

- **Picking the lines:** quotes, tagline and fail text come from the character.
- **The emblem:** `theme-import logo` only resizes. Drawing one, and choosing the Waybar glyph, is up to you.
- **Choosing the lock clip:** `theme-import lock` cuts and loops it, but finding a still-camera scene is manual.
- **Gallery previews:** the lock, GRUB and Plymouth screenshots.
- **A custom GRUB layout:** `theme.txt`, pixmaps and fonts by hand. Without one, every boot theme uses `_base/grub`.
- **Credits:** README entries by hand.
