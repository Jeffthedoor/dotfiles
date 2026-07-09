{ ... }:

{
  # power modes
  services.upower.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandlePowerKey = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
  };

  systemd.sleep.settings.Sleep.HibernateDelaySec = "30m";

  # power saving
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 45; # 45 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };
}
