{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false; # Disabled for Lanzaboote
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];

  # Binary Cache for CachyOS
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # System state version
  system.stateVersion = "25.11";
}
