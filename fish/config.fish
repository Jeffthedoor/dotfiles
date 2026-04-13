# function fishprompt -d "Write out the prompt"
# set -l color ffb452

# This shows up as USER@HOST /home/user/ >, with the directory colored
# $USER and $hostname are set by fish, so you can just use them
# instead of using `whoami` and `hostname`
# set_color $color
# printf '%s@%s %s%s%s > ' $USER $hostname \ (set_color $color) (prompt_pwd) (set_color $color)

# end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end

if command -q nix-your-shell
    nix-your-shell fish | source
end

# if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
#     cat ~/.cache/ags/user/generated/terminal/sequences.txt
# end

alias please=sudo
alias lg=lazygit
alias .='source ~/.config/fish/config.fish'
alias esrc='cd ~/.config/fish/; nvim ./config.fish'
alias tailup='sudo tailscale up --exit-node= --accept-routes'
alias tailtail='sudo tailscale up --exit-node=100.83.87.71'
alias econfig='cd /home/door/.config/; nvim ./nixos/'
alias ni='~/code/scripts/addpkg.fish'
alias gc='sudo nix-collect-garbage --delete-older-than 7d'
alias re='sudo nixos-rebuild switch --flake /home/door/.config/nixos#nixos'
alias n.="nvim ./"
alias eniri='cd ~/.config/niri; nvim ./'
alias hungry='/home/door/.cargo/bin/hungery'

ssh-add ~/.ssh/github_rsa &>/dev/null

function fish_greeting
    macchina --theme elektra
    set hour $(date +%H)
    if [ $hour -lt 12 ]
        set greet "Good morning, Jusnoor!"
    else if [ $hour -le 16 ]
        set greet "Good afternoon, Jusnoor!"
    else
        set greet "Good evening, Jusnoor!"
    end
    set_color red
    echo "$greet"
end

function update
    nix flake update --flake /home/door/.config/nixos
    sudo nix-channel --update
    sudo nixos-rebuild switch --flake /home/door/.config/nixos#nixos
    gc
end

# Hook direnv into fish
if type -q direnv
    direnv hook fish | source
end

# Auto-enter Distrobox
function auto_enter_ros2 --on-variable PWD
    # Define your workspace path explicitly
    set target_dir (realpath "$HOME/code/ros")
    set current_dir (realpath "$PWD")

    # If the paths match exactly...
    if test "$current_dir" = "$target_dir"
        # ...and we are NOT inside the container already
        if not test -f /run/.containerenv
            echo "⚡ Workspace detected. Launching Distrobox..."
            # Launch the container and explicitly start fish
            distrobox enter ros2-jazzy -- fish
        end
    end
end

zoxide init fish | source
