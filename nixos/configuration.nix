{
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # External flake modules
    inputs.spicetify-nix.nixosModules.default
    inputs.nirinit.nixosModules.default

    # Local modules
    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/hardware.nix
    ./modules/power.nix
    ./modules/desktop.nix
    ./modules/noctalia.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/packages.nix
    ./modules/games.nix
  ];

  system.stateVersion = "25.05"; # don't edit
}
