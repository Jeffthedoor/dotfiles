{ ... }:

{
  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.wifi.powersave = false;

  # networking.wireless.iwd.enable = true;
  # networking.wireless.iwd.settings = {
  #   IPv6 = {
  #     Enabled = true;
  #   };
  #   Settings = {
  #     AutoConnect = true;
  #   };
  # };

  # Enable networking
  networking.networkmanager = {
    enable = true;
    # wifi.backend = "iwd";
  };

  # Open ports in the firewall.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    57621 # spotify
    1740 # DS
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # spotify

    # DS
    1110
    1150
    1735
  ];
}
