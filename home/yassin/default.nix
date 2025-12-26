{ config, pkgs, ... }:

{
  imports = [
    ./theme.nix
    ./terminal.nix
    ./desktop.nix
  ];

  home.username = "yassin";
  home.homeDirectory = "/home/yassin";
  home.stateVersion = "25.11";
  home.sessionPath = [ "/home/yassin/.local/bin" ];

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  # Scroll config
  home.file.".config/scroll/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nixos/dotfiles/scroll/config";
}
