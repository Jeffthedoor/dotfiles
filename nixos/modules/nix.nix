{ ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Deduplicate and hard-link the store after each build
    auto-optimise-store = true;
  };

  # Automatic garbage collection so the store doesn't balloon
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
