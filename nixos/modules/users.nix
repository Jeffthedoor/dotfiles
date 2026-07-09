{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.door = {
    isNormalUser = true;
    description = "Jusnoor";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
      "input"
      "disks"
      "openrazer"
    ];
    packages = with pkgs; [ ];
  };

  # change default shell
  users.defaultUserShell = pkgs.fish;

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/tailscale";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-collect-garbage";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };
}
