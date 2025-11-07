{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "path:./nixvim";
    nixos-cli.url = "github:nix-community/nixos-cli";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-cli,
      ...
    }@inputs:

    let
      # temporary overlay for hyprland to fix ff crashing
      hyprlandOverlay = import ./overlay.nix;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./modules/documentation.nix
          inputs.home-manager.nixosModules.default
          nixos-cli.nixosModules.nixos-cli

          {
            nixpkgs.overlays = [ hyprlandOverlay ];
          }
        ];
      };
    };
}
