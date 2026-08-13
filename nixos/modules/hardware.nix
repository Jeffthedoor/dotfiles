{ pkgs, ... }:

{
  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.openrazer.enable = true;

  # firmware
  hardware.enableRedistributableFirmware = true;

  # regdom
  hardware.wirelessRegulatoryDatabase = true;

  # Enable fw-fanctrl systemd service and tools
  hardware.fw-fanctrl = {
    enable = true;
  };

  services = {
    # dock / displaylink
    xserver.videoDrivers = [
      "modesetting"
      "displaylink"
    ];

    hardware.bolt.enable = true;

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

    # CUPS
    printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver ];
    };

    # piper
    ratbagd.enable = true;

    # allows my flipper to be flashed. for some reason.
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666"
    '';
  };

  # displaylink manager
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];

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
}
