{
  config,
  pkgs,
  ...
}:

{
  # niri wayland compositor
  programs.niri.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # autologin / display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --sessions /${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
        user = "greeter";
      };
    };
  };

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

  # portals / dbus / dconf
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
  ];
  services.dbus.enable = true;
  programs.dconf.enable = true;
  security.polkit.enable = true;

  # audio
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
}
