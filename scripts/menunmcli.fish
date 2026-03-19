#!/usr/bin/env fish

function check
    set -l password $argv[1]
    set -l network $argv[2]
    if nmcli device wifi connect "$network" password "$password" 2>/dev/null
        notify-send "Password succeeded for $network"
    else
        notify-send -u critical "Password failed for $network"
    end
end

function forget_network
    if nmcli connection delete "$argv[1]" 2>/dev/null
        notify-send "$argv[1]" "Forgotten"
    else
        notify-send -u critical "$argv[1]" "Failed to forget"
    end
end

function connect_network
    set -l network $argv[1]
    set -l security (nmcli -t -f SSID,SECURITY device wifi list | grep "^$network:" | cut -d: -f2)
    if not nmcli -t -f NAME connection show | rg -qF "$network"; and test -n "$security"; and test "$security" != ""
        set -l password (fuzzel -w 50 --password -di --prompt-only="password: "); or return
        check "$password" "$network"
    else
        if nmcli device wifi connect "$network" 2>/dev/null
            notify-send "$network" "Connected"
        else
            notify-send -u critical "$network" "Failed to connect"
        end
    end
end

if test (nmcli radio wifi) = disabled
    notify-send -u critical "WiFi is not enabled"
    exit 1
end

set networks (nmcli -t -f SSID device wifi list | grep -v '^$' | sort -u)
if test -z "$networks"
    notify-send -u critical "No WiFi networks found"
    exit 1
end

set connected (nmcli -t -f SSID,ACTIVE device wifi list | grep ':yes$' | cut -d: -f1)
set choice (printf '%s\n' $networks | fuzzel --placeholder="$connected" -w 30 -di); or exit 1

if nmcli -t -f NAME connection show | rg -qF "$choice"
    set is_known yes
else
    set is_known no
end

if test "$choice" = "$connected"
    set action (printf "Disconnect\nForget" | fuzzel -w 20 -di); or exit 1
    switch $action
        case Disconnect
            nmcli device disconnect wlan0; and notify-send "$choice" "Disconnected"
        case Forget
            forget_network "$choice"
    end
else if test "$is_known" = yes
    set action (printf "Connect\nForget" | fuzzel -w 20 -di); or exit 1
    switch $action
        case Connect
            connect_network "$choice"
        case Forget
            forget_network "$choice"
    end
else
    connect_network "$choice"
end
