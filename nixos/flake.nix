{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "path:./nixvim";
    nixos-cli.url = "github:nix-community/nixos-cli";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
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
          nixos-cli.nixosModules.nixos-cli

          inputs.minegrub-world-sel-theme.nixosModules.default

          # {
          #   nixpkgs.overlays = [ hyprlandOverlay ];
          # }
        ];
      };
    };
}
