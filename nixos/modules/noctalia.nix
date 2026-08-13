{ pkgs, inputs, ... }:

{
  # This module contains the complete Noctalia integration. Remove its import
  # from configuration.nix and the `noctalia` flake input to uninstall it.
  imports = [ inputs.noctalia.nixosModules.default ];

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  programs.noctalia = {
    enable = true;
    # NetworkManager, Bluetooth, UPower, and power-profiles-daemon are already
    # configured elsewhere; this keeps that expected service set explicit.
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    python3
  ];
}
