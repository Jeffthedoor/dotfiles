{ inputs, pkgs, ... }:

{
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

        # Remember to update this with the real hash after the first build fails!
        cargoHash = prev.lib.fakeHash;
      };
    })
  ];
}
