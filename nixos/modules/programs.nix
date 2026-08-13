{
  pkgs,
  inputs,
  ...
}:

{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs.git.enable = true;
  programs.fish.enable = true;
  # programs.foot.enable = true;

  programs.direnv.enable = true;
  programs.thunar.enable = true;
  programs.gnome-disks.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };
  programs.steam.enable = true;

  # thunar helpers
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # appimage compat
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

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

        bookmark
      ];

      theme = spicePkgs.themes.text;
      # colorScheme = "mocha";
    };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;

    defaultNetwork.settings.dns_enabled = true;
  };
}
