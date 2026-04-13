{ inputs, pkgs, ... }:

{
  # 1. The Overlay (builds the package)
  nixpkgs.overlays = [
    (final: prev: {
      pandora = prev.rustPlatform.buildRustPackage {
        pname = "pandora";
        version = "git";
        src = inputs.pandora;

        nativeBuildInputs = with prev; [ pkg-config ];
        buildInputs = with prev; [
          wayland
          libxkbcommon
        ];

        cargoHash = "sha256-enZrVnzsQScDTFrU1awt/cAg6qdzyWtBoiGlVw/4C14=";
      };
    })
  ];

  # 2. Install the package system-wide (optional, but good for testing in terminal)
  environment.systemPackages = [ pkgs.pandora ];

  # 3. The Systemd User Service
  systemd.user.services.pandora = {
    description = "Pandora Wayland Wallpaper Daemon";

    # [Unit] section
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];

    # Required to actually enable and start the service automatically
    wantedBy = [ "graphical-session.target" ];

    # [Service] section
    serviceConfig = {
      # Use the Nix-built binary directly
      ExecStart = "${pkgs.pandora}/bin/pandora";
      Restart = "on-failure";
    };
  };
}
