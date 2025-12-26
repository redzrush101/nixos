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
}
