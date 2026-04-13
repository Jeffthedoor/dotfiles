{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # nix.settings = {
  #   substituters = [ "https://hyprland.cachix.org" ];
  #   trusted-substituters = [ "https://hyprland.cachix.org" ];
  #   trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  # };
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.spicetify-nix.nixosModules.default
    inputs.nirinit.nixosModules.default
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
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
      "openrazer"
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
    tuigreet # lock screen agent
    hyprpicker # color picker
    swww # wallpaper setter
    fuzzel # launcher
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
    pandora # scrollable wallpaper

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
    inputs.nixvim.packages.x86_64-linux.default
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
    inputs.niri-scratchpad.packages.${pkgs.system}.default # scratchpad

    # shell utils
    zoxide # better cd
    bat # better cat
    ripgrep # grep
    dig # dns inspector
    jq # json parser

    # git, fish, and foot are declared lower because nix is ass

    # gui apps
    # gaming
    prismlauncher # minecraft
    vesktop # wordle
    moonlight-qt # FUCK windows
    openrazer-daemon # razer mouse config
    polychromatic # razer led config
    piper # logitech mouse config

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
    superfile # file manager
    slack

    # etc
    angryipscanner
    evtest
    progress
    meow
    distrobox
    macchina
  ];

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    dejavu_fonts
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "DejaVu Sans" ];
    serif = [ "DejaVu Sans Serif" ];
    monospace = [ "DejaVu Sans Mono" ];
  };

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

  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  security.polkit.enable = true;

  services = {
    # hardware shit
    # dock
    xserver.videoDrivers = [
      "modesetting"
    ];

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];
        settings.global = {
          overload_tap_timeout = 200; # Milliseconds to register a tap before timeout
        };
        settings.main = {
          leftmeta = "overload(meta, M-f12)";
        };
      };
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
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --sessions /${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
          user = "greeter";
        };
      };
    };
    # gtk.iconCache.enable = true;
    # tailscale
    tailscale.enable = true;

    # keyring
    gnome.gnome-keyring.enable = true;

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

    # nirinit
    nirinit = {
      enable = true;
      settings = {
        # Map app_id to launch command (useful for PWAs, flatpaks, etc.)
        launch = {
        };
        # Apps to skip during restore
        skip.apps = [ "steam" ];
      };
    };

  };
  # end services

  # grub theme
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    useOSProber = true; # find arch and windows

    minegrub-world-sel = {
      enable = true;
      customIcons = with config.system; [
        {
          inherit name;
          lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
          lineBottom = "Survival Mode, No Cheats, Version: " + nixos.release;

          # Icon: you can use an icon from the remote repo, or load from a local file
          imgname = "nixos";
        }
        {
          name = "windows";
          lineTop = "Windows 10";
          lineBottom = "Creative Mode, Cheats Enabled, Version: 23H2";
          imgName = "windows";
        }
        {
          name = "arch";
          lineTop = "Arch Linux (Rolling Release)";
          lineBottom = "Hardcore Mode, No Cheats, Version: Rolling";
          imgName = "arch";
        }
      ];
    };
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "green_blocks";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "green_blocks" ];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"

      "resume_offset=1943552"
      "mem_sleep_default=deep"
      "module_blacklist=hid_sensor_hub"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 5;
    resumeDevice = "/dev/disk/by-uuid/14d73c8b-a5d5-4a01-8bd0-40b5bec149b3";

  };

  # swap and hibernate
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30m";

  # extra greetd config
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

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

  # systemd.services.tlp-sleep-hook = {
  #   description = "Adjust TLP charging thresholds on sleep/wake based on time";
  #   wantedBy = [ "sleep.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = ''
  #       HOUR=$(date +%H)
  #       if [ "$HOUR" -ge 22 ] || [ "$HOUR" -lt 8 ]; then
  #         ${pkgs.tlp}/bin/tlp setcharge BAT0 0 100
  #       else
  #         ${pkgs.tlp}/bin/tlp setcharge BAT0 45 80
  #       fi
  #     '';
  #   };
  # };

  # fprintd
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  security.pam.services = {
    # enable fprinted for everything
    sddm.fprintAuth = false;
    sddm-autologin.fprintAuth = false;
    login.fprintAuth = false;
    sudo.fprintAuth = true;
    kscreenlocker.fprintAuth = true;
    polkit-1.fprintAuth = true;

    login.enableGnomeKeyring = true; # auto-unlock gnome-keyring
  };

  # appimage compat
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # networking and related services
  # OpenSSH
  # services.openssh.enable = true;
  # programs.ssh.startAgent = true;

  # Open ports in the firewall.
  networking.firewall.enable = false;
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
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.openrazer.enable = true;

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
  programs.steam.enable = true;

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

  # essentially lets appimages run out of the box
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      sentry-native
      steam
      libxxf86vm
      openssl
      libGLU
      libGL
      e2fsprogs
      libunistring
      glfw
      wayland
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;

    defaultNetwork.settings.dns_enabled = true;
  };

  system.stateVersion = "25.05"; # don't edit
}
