{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.spicetify-nix.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    IPv6 = {
      Enabled = true;
    };
    Settings = {
      AutoConnect = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.door = {
    isNormalUser = true;
    description = "Jusnoor";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
      "input"
      "disks"
    ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # change default shell
  users.defaultUserShell = pkgs.fish;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # DE
    libnotify # notification manager
    brightnessctl # god i wonder
    hypridle # idle agent
    hyprsunset # blue light filter that is unused
    hyprlock # lock screen agent
    hyprpicker # color picker
    hyprpaper # wallpaper setter
    rofi # launcher
    grimblast # screenshot manager
    hyprpicker # color picker
    libgtop # system hardware utilization daemon
    gvfs # gnome virtual file system for some reason
    cliphist # clipboard history
    wl-clipboard # clipboard manager
    tesseract # ocr
    nordzy-cursor-theme # my cursor
    xdotool # virtual keyboard/mouse
    nwg-look # gnome colors config. probably unecessary?
    nix-search-cli # what do you think
    xwayland-satellite
    displaylink # fuckass drivers for my fuckass dock

    # [expirimenta] waybar reqs
    waybar
    mako # notification daemon
    bluez
    fzf
    pulseaudio

    # tui utilities
    # development
    inputs.nixvim.packages.x86_64-linux.default
    # inputs.niri-caelestia-shell.default
    vim
    bear # cmake helper file generator
    nix-direnv # nix dev environments
    lazygit # ily lazygit <3
    zellij # terminal multiplexer

    # general utils
    tldr # man't pages
    pfetch-rs # hmmmm
    nitch # other fetcher
    unzip # now this ones a toughie
    btop # frick task manager
    feh # image viewer
    impala # tui wifi
    bluetui # tui bluetooth
    element # periodic table
    cava # sound digitizer
    nix-your-shell # make nix-shells use fish
    zoxide # better cd
    bat # better cat

    # git, fish, and foot are declared lower because nix is ass

    # gui apps
    # gaming
    prismlauncher # minecraft
    vesktop # wordle
    moonlight-qt # FUCK windows

    # media
    # spotify # favorite porn app
    vlc # favorite music app
    plex-desktop # favorite notes app
    obsidian # volcanic glass
    firefoxpwa

    # productivity
    libreoffice-qt # FUCK windows v2.
    hunspell # (dep of libreoffice)
    elinks # weird web browser
    vscode-fhs # what do you think
    carla
    piper
    superfile
    abaddon
    xournalpp
    fw-ectool
  ];

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/tailscale";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-collect-garbage";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  # dock
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  security.polkit.enable = true;

  services = {
    # hardware shit
    # dock
    xserver.videoDrivers = [
      "displaylink"
      "modesetting"
    ];

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # fwupdating
    fwupd.enable = true;

    # power modes
    # power-profiles-daemon.enable = true;
    upower.enable = true;

    #CUPS
    printing.enable = true;
    playerctld.enable = true;

    # userspace stuff
    #autologin
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.niri}/bin/niri-session";
          user = "door";
        };
        default_session = initial_session;
      };
    };

    # tailscale
    tailscale.enable = true;

    # StartTree server
    static-web-server = {
      enable = true;
      root = "/home/door/.cache/StartTree/";
    };

    # allows my flipper to be flashed. for some reason.
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666"
    '';

    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
      HandleLidSwitchDocked = "suspend-then-hibernate";
    };

    # thunar stuff
    gvfs.enable = true;
    tumbler.enable = true;

    #piper
    ratbagd.enable = true;

    # flatpak
    flatpak.enable = true;
  };
  # end services

  # swap and hibernate
  boot.kernelParams = [
    "resume_offset=1943552"
    "mem_sleep_default=deep"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/14d73c8b-a5d5-4a01-8bd0-40b5bec149b3";
  powerManagement.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";

  # power saving
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 45; # 45 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };
  # Systemd service that runs on sleep/wake to ensure minimum battery cycles while docked, and max battery in the morning

  systemd.services.tlp-sleep-hook = {
    description = "Adjust TLP charging thresholds on sleep/wake based on time";
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        HOUR=$(date +%H)
        if [ "$HOUR" -ge 22 ] || [ "$HOUR" -lt 8 ]; then
          ${pkgs.tlp}/bin/tlp setcharge BAT0 0 100
        else
          ${pkgs.tlp}/bin/tlp setcharge BAT0 45 80
        fi
      '';
    };
  };

  # fprintd
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  security.pam.services = {
    sddm.fprintAuth = false;
    sddm-autologin.fprintAuth = false;
    login.fprintAuth = false;
    sudo.fprintAuth = true;
    kscreenlocker.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };

  # appimage compat
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # networking and related services
  # OpenSSH
  # services.openssh.enable = true;
  # programs.ssh.startAgent = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    57621 # spotify
    1740 # DS
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # spotify

    # DS
    1110
    1150
    1735
  ];

  #bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  #pipewire
  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };

  # system apps
  programs.niri.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
    # pkgs.gnome-keyring
  ];
  services.dbus.enable = true;
  programs.dconf.enable = true;

  # user-space apps
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs.git.enable = true;
  programs.fish.enable = true;
  programs.foot.enable = true;
  programs.direnv.enable = true;
  programs.thunar.enable = true;
  programs.gnome-disks.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  # https://wiki.nixos.org/wiki/Spicetify-Nix
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        popupLyrics

        catJamSynced
        wikify
        bookmark
      ];

      theme = spicePkgs.themes.starryNight;
      # colorScheme = "mocha";
    };

  system.stateVersion = "25.05"; # don't edit
}
