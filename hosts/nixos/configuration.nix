{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware-tweaks.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/graphics.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/virtualisation.nix
    ../../modules/nixos/filesystems.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/users.nix
  ];
}
