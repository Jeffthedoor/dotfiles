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
    # inputs.hyprland.nixosModules.default
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
    hyprpolkitagent # keyring agent
    hypridle # idle agent
    hyprsunset # blue light filter that is unused
    hyprlock # lock screen agent
    hyprpicker # color picker
    hyprpaper # wallpaper setter
    # hyprspace # workspace manager
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
    vim
    bear # cmake helper file generator
    nix-direnv # nix dev environments
    lazygit # ily lazygit <3
    tiny8086 # itty bitty assembly parser

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
    spotify # favorite porn app
    vlc # favorite music app
    plex-desktop # favorite notes app
    obsidian # volcanic glass

    # productivity
    libreoffice-qt # FUCK windows v2.
    hunspell # (dep of libreoffice)
    elinks # weird web browser
    vscode-fhs # what do you think
    carla
    piper
    superfile

    hyprlandPlugins.hyprspace
    hyprlandPlugins.hyprsplit
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
    power-profiles-daemon.enable = true;
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
          command = "hyprland > /dev/null 2>&1";
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
      HibernateDelaySec = "30m";
    };

    # thunar stuff
    gvfs.enable = true;
    tumbler.enable = true;

    #piper
    ratbagd.enable = true;
  };

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
  # systemd.sleep.extraConfig = ''
  #   SuspendState=s2idle
  # '';

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
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

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
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    # plugins = with inputs; [
    #   hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    #   Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
    #   # hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking
    # ];
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  system.stateVersion = "25.05"; # don't edit
}
