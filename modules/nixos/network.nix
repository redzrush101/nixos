{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.hostName = "nixos";

  # Networking via systemd-networkd + IWD
  networking.networkmanager.enable = false;

  networking.wireless.iwd = {
    enable = true;
    settings.Network.EnableNetworkConfiguration = true;
  };

  systemd.network.enable = true;
  networking.useNetworkd = true;

  systemd.network.networks = {
    "10-wired" = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };
    "20-wireless" = {
      matchConfig.Name = "wl*";
      networkConfig.DHCP = "yes";
      networkConfig.IgnoreCarrierLoss = "3s";
    };
  };

  services.resolved.enable = true;

  # Locale settings
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
}
