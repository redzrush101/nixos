{ config, pkgs, ... }:

{
  networking.hostName = "desktop";

  imports = [
    ./hardware.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/desktop.nix
  ];

  system.stateVersion = "25.11";
}
