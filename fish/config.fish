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

# if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
#     cat ~/.cache/ags/user/generated/terminal/sequences.txt
# end

alias pamcan=pacman
alias gte='/usr/bin/gnome-text-editor $argv'
alias dsc='/usr/bin/discord-ptb &'
alias ab='/usr/bin/abricotine'
alias please=sudo
alias lg=lazygit
alias src='source ~/.config/fish/config.fish'
alias esrc='nvim ~/.config/fish/config.fish'
alias taildesk='sudo tailscale up --exit-node=100.108.10.152'
alias tailend='sudo tailscale up --exit-node='
alias tailtail='sudo tailscale up --exit-node=100.83.87.71'

function fish_greeting
    #    neofetch
    pfetch
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
