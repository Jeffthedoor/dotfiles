{
  description = "system flake";

  # Make Noctalia's cache available while building the generation that enables
  # the same settings system-wide in modules/noctalia.nix.
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

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
    # Kept separate from nixpkgs to use Noctalia's binary cache.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
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
          nixos-cli.nixosModules.nixos-cli
          inputs.minegrub-world-sel-theme.nixosModules.default
        ];
      };
    };
}
