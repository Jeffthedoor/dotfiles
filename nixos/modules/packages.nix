{
  pkgs,
  inputs,
  ...
}:

{
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # DE
    libnotify # notification manager
    brightnessctl # god i wonder
    tuigreet # lock screen agent
    hyprpicker # color picker
    wbg # wallpaper setter
    fuzzel # launcher
    matugen # material-you palette generator (theme-menu "material from wallpaper")
    grimblast # screenshot manager
    libgtop # system hardware utilization daemon
    gvfs # gvfs CLI (gio etc.); the daemon comes from services.gvfs
    cliphist # clipboard history
    wl-clipboard # clipboard manager
    tesseract # ocr
    nordzy-cursor-theme # my cursor
    xdotool # virtual keyboard/mouse
    nwg-look # gnome colors config. probably unecessary?
    nix-search-cli # what do you think
    xwayland-satellite
    swayidle
    hyprlock
    inputs.nirimod.packages.${pkgs.stdenv.hostPlatform.system}.default

    # waybar reqs
    waybar
    waybar-lyric
    mako # notification daemon
    bluez # bluetooth daemon
    fzf # fuzzy finder
    pulseaudio # sound server
    wttrbar # weather in waybar

    # tui utilities
    # development
    inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    vim
    bear # cmake helper file generator
    nix-direnv # nix dev environments
    lazygit # ily lazygit <3
    zellij # terminal multiplexer
    fw-ectool # framework led control

    # general utils
    tldr # man't pages
    pfetch-rs # hmmmm
    nitch # other fetcher
    unzip # now this ones a toughie
    btop # frick task manager
    feh # image viewer
    wiremix # tui pulseaudio mixer
    element # periodic table
    cava # sound digitizer
    nix-your-shell # make nix-shells use fish
    pciutils # minecraft
    vulkan-loader # vulkan
    libGL # openGL
    inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default # scratchpad
    ddcutil

    # shell utils
    zoxide # better cd
    bat # better cat
    ripgrep # grep
    dig # dns inspector
    jq # json parser

    # git, fish, are declared lower because nix is ass

    # gui apps
    vesktop # wordle
    # moonlight-qt # FUCK windows
    openrazer-daemon # razer mouse config
    piper # logitech mouse config
    ghostty

    # media
    vlc # favorite music app
    plex-desktop # favorite notes app
    obsidian # volcanic glass
    floorp-bin-unwrapped # browser
    plezy # plex frontend

    # productivity
    libreoffice-qt # FUCK windows v2.
    hunspell # (dep of libreoffice)
    elinks # weird web browser
    vscode # what do you think
    code-cursor-fhs
    superfile # file manager
    slack

    # etc
    angryipscanner
    evtest
    progress
    meow
    distrobox
    macchina
    ffmpeg
    yt-dlp
    obs-studio
    p7zip

    usbutils
    dmidecode
    iw
    inxi
    lm_sensors
    spotify-player
    gptfdisk
    prusa-slicer
  ];

  documentation = {
    # Keep these disabled if you want to save space
    info.enable = false;
    nixos.enable = false;

    man = {
      enable = true;
      # Enable the man-db cache
      cache.enable = true;
      # Delegate cache generation to a background systemd service
      # rather than blocking your system rebuilds
      cache.generateAtRuntime = true;
    };
  };

  environment.variables = {
    MANWIDTH = "80";
    MANROFFOPT = "-P -c";
  };
}
