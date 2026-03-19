#!/usr/bin/env fish

set sinks (pactl list sinks short | awk '{print $2}')
if test -z "$sinks"
    notify-send -u critical "PulseAudio" "No audio outputs found"
    exit 1
end

set default_sink (pactl get-default-sink)

set display_list
for sink in $sinks
    set -l desc (pactl list sinks | grep -A 50 "Name: $sink" | grep "Description:" | head -1 | sed 's/.*Description: //')
    if test "$sink" = "$default_sink"
        set -a display_list "$desc *"
    else
        set -a display_list "$desc"
    end
end

if test (count $sinks) -gt 1
    set choice (printf '%s\n' $display_list | fuzzel -w 50 -di); or exit 1
    set choice (string replace ' *' '' "$choice")
    
    set selected_sink
    for sink in $sinks
        set -l desc (pactl list sinks | grep -A 50 "Name: $sink" | grep "Description:" | head -1 | sed 's/.*Description: //')
        if test "$desc" = "$choice"
            set selected_sink $sink
            break
        end
    end
else
    set selected_sink $sinks[1]
end

if test -n "$selected_sink"
    if pactl set-default-sink "$selected_sink"
        notify-send "Audio Output" "Switched to $choice"
    else
        notify-send -u critical "Audio Output" "Failed to switch"
    end
end
