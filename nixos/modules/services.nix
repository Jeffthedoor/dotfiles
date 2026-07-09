{ ... }:

{
  services = {
    # NTP
    chrony = {
      enable = true;
      servers = [
        "0.north-america.pool.ntp.org"
        "1.north-america.pool.ntp.org"
        "2.north-america.pool.ntp.org"
        "time.cloudflare.com"
      ];
    };

    playerctld.enable = true;

    # tailscale
    tailscale.enable = true;

    # keyring
    gnome.gnome-keyring.enable = true;

    # StartTree server
    static-web-server = {
      enable = true;
      root = "/home/door/.cache/StartTree/";
    };

    # flatpak
    flatpak.enable = true;
  };
}
