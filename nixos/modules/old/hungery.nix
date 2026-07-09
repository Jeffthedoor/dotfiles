{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # 1. Define the overlay to inject hungery into pkgs
  nixpkgs.overlays = [
    (final: prev: {
      # Grab the compiled package from the flake input
      hungery = inputs.hungery.packages.${prev.system}.default;
    })
  ];

  # 2. Install it globally using the new pkgs attribute
  environment.systemPackages = [
    pkgs.hungery
  ];
}
