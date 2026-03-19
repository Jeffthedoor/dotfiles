#!/usr/bin/env fish

set choice (printf "Logout\nReboot\nShutdown\nSuspend" | fuzzel -w 10 -di)
switch $choice
    case Logout
        niri msg quit
    case Reboot
        loginctl reboot
    case Shutdown
        loginctl poweroff
    case Suspend
        loginctl suspend
end
