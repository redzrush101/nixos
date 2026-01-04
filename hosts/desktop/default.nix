{ config, pkgs, ... }:

{
  networking.hostName = "desktop";

  imports = [
    ./hardware.nix
    # Core
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/locale.nix
    # Hardware
    ../../modules/nixos/hardware/graphics.nix
    ../../modules/nixos/hardware/audio.nix
    ../../modules/nixos/hardware/filesystems.nix
    ../../modules/nixos/hardware/drivers.nix
    # Services
    ../../modules/nixos/services/networking.nix
    ../../modules/nixos/services/virtualisation.nix
    # Desktop
    ../../modules/nixos/desktop/packages.nix
    ../../modules/nixos/desktop/users.nix
  ];

  system.stateVersion = "25.11";
}
