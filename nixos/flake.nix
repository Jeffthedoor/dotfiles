{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "path:./nixvim";
    nixos-cli.url = "github:nix-community/nixos-cli";
    hyprland.url = "github:hyprwm/Hyprland/v0.51.1";
    # waybar.url = "github:Alexays/Waybar/update_flake_lock_action";

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # hyprsplit = {
    #   url = "github:shezdy/hyprsplit";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   inputs.hyprland.follows = "hyprland";
    # };
    #
    # hyprtasking = {
    #   url = "github:raybbian/hyprtasking";
    #   inputs.hyprland.follows = "hyprland";
    # };

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

          # (
          #   { pkgs, ... }:
          #   {
          #     nixpkgs.overlays = [
          #       (_: _: { waybar_git = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar; })
          #     ];
          #   }
          # )

          # {
          #   nixpkgs.overlays = [ hyprlandOverlay ];
          # }
        ];
      };
    };
}
