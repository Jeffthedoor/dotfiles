{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "path:./nixvim";
    nixos-cli.url = "github:nix-community/nixos-cli";
    hyprland.url = "github:hyprwm/Hyprland/v0.51.1";
    # waybar.url = "github:Alexays/Waybar/update_flake_lock_action";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-caelestia-shell = {
      url = "github:jutraim/niri-caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-cli,
      spicetify-nix,
      ...
    }@inputs:

    let
      # temporary overlay for hyprland to fix ff crashing
      # hyprlandOverlay = import ./overlay.nix;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./modules/documentation.nix
          inputs.home-manager.nixosModules.default
          nixos-cli.nixosModules.nixos-cli

          # {
          #   nixpkgs.overlays = [ hyprlandOverlay ];
          # }
        ];
      };
    };
}
