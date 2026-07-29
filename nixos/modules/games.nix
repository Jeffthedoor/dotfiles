{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      # This ensures Prism Launcher sees these Java versions
      jdks = [
        jdk8
        jdk17
        jdk21
        jdk25
      ];
    })
  ];

  # essentially lets appimages run out of the box
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      sentry-native
      steam
      libxxf86vm
      openssl
      libGLU
      libGL
      e2fsprogs
      libunistring
      glfw
      wayland
      SDL2
      libsm
      libice
      libxcb
    ];
  };

}
