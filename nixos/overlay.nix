# overlay.nix
final: prev: {
  hyprland = prev.hyprland.overrideAttrs (old: {
    version = "0.51.1-patched";
    src = prev.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprland";
      rev = "ab11af9664a80df70fe3398810b79c4298312a33";
      hash = "sha256-dSAPRyKzxM+JodX5xBCmpVrVYWjYpNPPiSySaI4W+rQ=";
      fetchSubmodules = true;
    };
  });
}
