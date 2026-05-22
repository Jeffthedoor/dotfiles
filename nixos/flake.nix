{
  description = "system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "path:./nixvim";
    nixos-cli.url = "github:nix-community/nixos-cli";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    niri-scratchpad.url = "github:argosnothing/niri-scratchpad";
    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pandora = {
      url = "github:PandorasFox/pandora";
      flake = false;
    };
    nirimod = {
      url = "github:srinivasr/nirimod";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hungery.url = "path:/home/door/code/rust/hungery";

  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-cli,
      spicetify-nix,
      nirinit,
      nirimod,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./modules/documentation.nix
          # ./modules/pandora.nix
          # ./modules/hungery.nix
          nixos-cli.nixosModules.nixos-cli

          inputs.minegrub-world-sel-theme.nixosModules.default
        ];
      };
    };
}
