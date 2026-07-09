# Theme system

One **base16** palette drives colors for every configurable app. Pick a theme
(or generate one from a wallpaper) and every app updates, live where possible.

## Use it

- **Menu:** `Mod+Shift+C` (niri) → Theme / Wallpaper / Material-from-wallpaper.
- **CLI:**
  - `~/.config/scripts/theme.fish apply <name>` — e.g. `apply nord`
  - `~/.config/scripts/theme.fish list` / `current`
  - `~/.config/scripts/theme.fish matugen [image]` — Material palette from an
    image (defaults to the current wallpaper). Needs `matugen` installed.

## Layout

| Path | What |
|------|------|
| `palettes/*.conf` | base16 palettes (`base00`..`base0F`, `name`, `mode`) |
| `current.conf` / `current-name` | active palette + its name |
| `current-wallpaper` | last wallpaper set via the menu (niri reads it at startup) |
| `~/.config/scripts/theme.fish` | engine: renders every app, reloads them |
| `~/.config/scripts/theme-menu.fish` | fuzzel front-end |
| `~/.config/matugen/` | matugen config + base16 template |

## Apps driven

| App | How | Live reload |
|-----|-----|-------------|
| foot | rewrites `[colors-dark]`+`[colors-light]` in `foot.ini` | yes — live OSC recolor to open ptys (foot's SIGUSR1/USR2 only *switch* dark/light, they don't re-read the file) |
| fuzzel | rewrites `[colors]` in `fuzzel.ini` | on next launch |
| waybar | regenerates `theme.css` | yes (`SIGUSR2`) |
| mako | updates color keys | yes (`makoctl reload`) |
| vscode | `workbench.colorCustomizations` in `settings.json` | yes, no extension needed |
| gtk 3/4 | dark/light pref + `@define-color` in `gtk.css` | new windows |
| qt5ct/qt6ct | generated QPalette scheme | app restart |
| nvim | **not managed** — it's in nixvim (immutable) |

## Add a theme

Drop a `palettes/<name>.conf` (copy an existing one, swap the 16 hex values).
It shows up in the menu automatically. base16 schemes from
tinted-theming/base16 work directly.

## Notes

- Originals were backed up once as `*.themebak` next to each edited file.
- Matugen mapping (Material-You → base16) is approximate; accents lean
  monochromatic since Material isn't a 16-color system.
