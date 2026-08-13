{
  config,
  pkgs,
  ...
}:

{
  boot = {
    # iw reg setting
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;

      grub = {
        enable = true;
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
    };

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

    # networking settings
    kernel.sysctl = {
      # Increase the maximum receive buffer size for network packets (2 GiB)
      "net.core.rmem_max" = 2147483647;

      # IP fragmentation settings
      "net.ipv4.ipfrag_time" = 3;
      "net.ipv4.ipfrag_high_thresh" = 134217728;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    resumeDevice = "/dev/disk/by-uuid/14d73c8b-a5d5-4a01-8bd0-40b5bec149b3";
  };

  # swap and hibernate
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 30 * 1024; # 16GB in MB
    }
  ];

  # TEST
  systemd.oomd.enable = true;
  zramSwap.enable = true;

}
