#!/usr/bin/env fish
#
# theme-menu.fish — fuzzel front-end for the theme engine (theme.fish)
#
# Main menu → Theme / Wallpaper / Material-from-wallpaper submenus.

set -g THEME "$HOME/.config/scripts/theme.fish"
set -g THEMES_DIR "$HOME/.config/themes"
set -g WALLS "$HOME/Pictures/walls"

function menu
    # $argv[1] = prompt, stdin = newline-separated entries
    fuzzel --dmenu -i -w 34 --prompt "$argv[1] "
end

function pick_theme
    set -l cur (cat "$THEMES_DIR/current-name" 2>/dev/null)
    set -l entries
    set -l moon (printf '')
    set -l sun (printf '')
    set -l dot (printf '')
    set -l ring (printf '')
    for f in $THEMES_DIR/palettes/*.conf
        set -l n (basename $f .conf)
        set -l icon $moon
        grep -q '^mode=light' $f; and set icon $sun
        set -l mark $ring
        test "$n" = "$cur"; and set mark $dot
        set -a entries "$icon $mark $n"
    end
    set -l choice (printf '%s\n' $entries | menu "theme")
    test -z "$choice"; and return 1
    set -l name (string split ' ' -- $choice)[-1]
    $THEME apply $name
end

function pick_wallpaper
    test -d $WALLS; or begin
        printf '' | menu "no ~/Pictures/walls"
        return 1
    end
    set -l choice (find $WALLS -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -printf '%f\n' | sort | menu "wallpaper")
    test -z "$choice"; and return 1
    set -l path "$WALLS/$choice"
    pkill wbg 2>/dev/null
    setsid -f wbg -s "$path" 2>/dev/null
    echo "$path" >"$THEMES_DIR/current-wallpaper"
end

function main_menu
    set -l cur (cat "$THEMES_DIR/current-name" 2>/dev/null; or echo none)
    printf '%s\n' " Theme        (now: $cur)" " Wallpaper" " Material from wallpaper" | menu "colors"
end

set -l choice (main_menu)
switch "$choice"
    case '* Theme*'
        pick_theme
    case '* Wallpaper*'
        pick_wallpaper
    case '* Material*'
        set -l out ($THEME matugen 2>&1)
        test $status -ne 0; and printf '%s\n' $out | menu "matugen"
    case '*'
        exit 0
end
