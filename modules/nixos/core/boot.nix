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
  
  # Note: boot.extraModulePackages moved to hardware/drivers.nix
}
