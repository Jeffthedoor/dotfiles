#!/usr/bin/env fish

function toggle
    set -l action $argv[1]
    if bluetoothctl $action $mac
        notify-send "$device" "Successfully {$action}ed"
    else
        notify-send -u critical "$device" "Failed to $action"
    end
end

if bluetoothctl show | grep -q "Powered: no"
    notify-send -u critical "Bluetooth" "Disabled"
    exit 1
end

set saved (bluetoothctl devices | grep "^Device")
if test -z "$saved"
    notify-send -u critical "Bluetooth" "No saved devices"
    exit 1
end

set connected (bluetoothctl devices Connected | grep "^Device")
set devices
for line in $saved
    if echo "$connected" | grep -q "$line"
        set -a devices "$line *"
    else
        set -a devices "$line"
    end
end

if test (count $saved) -gt 1
    set choice (printf '%s\n' $devices | cut -d' ' -f3- | sort | fuzzel -w 30 -di); or exit 1
    if echo "$choice" | grep -q '\*'
        set choice (echo "$choice" | cut -d' ' -f1)
    end
    set device (printf '%s\n' $saved | grep "$choice" | cut -d' ' -f3)
    set mac (printf '%s\n' $saved | grep "$choice" | cut -d' ' -f2)
else
    set device (echo "$saved" | cut -d' ' -f3)
    set mac (echo "$saved" | cut -d' ' -f2)
end

if echo "$connected" | grep -q "$mac"
    toggle disconnect
else
    toggle connect
end
