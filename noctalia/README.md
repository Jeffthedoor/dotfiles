# Noctalia configuration

Noctalia loads its settings as two layers:

1. **This directory** (`~/.config/noctalia/`) — every `*.toml` file here is merged
   together, in filename order. This is the tracked, reproducible base.
2. **`~/.local/state/noctalia/settings.toml`** — overrides written by the settings
   GUI at runtime. Anything set here wins over this directory.

Noctalia only ever *reads* this directory, so comments and file layout are safe.
It writes only the keys you actually change into the state file, not a full dump.

## Files

| File | Contents |
| --- | --- |
| `10-shell.toml` | Launcher, panels, session actions, control center shortcuts |
| `20-bar.toml` | Bar layout: monitors, sections, capsule groups |
| `30-widgets.toml` | Per-widget settings, including plugin widgets |
| `40-lockscreen-and-desktop.toml` | Lockscreen and desktop widget canvases |
| `50-theme.toml` | Colour scheme, fonts, radius, opacity |
| `60-wallpaper.toml` | Wallpaper sources and per-monitor assignments |
| `70-system.toml` | Battery, brightness, idle, location, weather, sysmon |
| `80-plugins.toml` | Enabled plugins, plugin sources, per-plugin settings |

## Workflow

Change things in the GUI as usual. They land in the state file as a small delta:

    cat ~/.local/state/noctalia/settings.toml

When you are happy with a change, promote it into the right file here, then blank
the state file back down to just its version marker so this directory stays
authoritative:

    printf 'config_version = 12\n' > ~/.local/state/noctalia/settings.toml
    noctalia msg config-reload

Verify the merged result is what you expect at any point:

    noctalia config validate          # checks the full stack the shell loads
    noctalia config export merged     # prints the merged user config
    noctalia config export full       # merged config plus built-in defaults

`config_version` is a migration marker owned by Noctalia. Leave it in the state
file; it is deliberately not part of the exported config.

## Notes

- `noctalia config validate` reports one warning, `widget.ram.display: unknown
  setting` in `30-widgets.toml`. That key predates this split and no longer maps
  to anything in Noctalia 5; it is kept only to preserve the original config and
  can be deleted.
- The plugins in `80-plugins.toml` are fetched at runtime into
  `~/.local/state/noctalia/plugins/`, which is not tracked. `plugins.auto_update`
  means their versions are not pinned by this directory.
