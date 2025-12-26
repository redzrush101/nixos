{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    swayidle
    wlsunset
    i3blocks
    pamixer
    swaybg
    socat
    grim
    slurp
    swappy
    wl-clipboard
    playerctl
  ];

  home.file.".config/wallpapers".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nixos/dotfiles/wallpapers";

  programs.swaylock = {
    enable = true;
    settings = {
      color = "1e1e2e";
      inside-color = "1e1e2e";
      inside-clear-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      key-hl-color = "b4befe";
      bs-hl-color = "f38ba8";
      ring-color = "313244";
      ring-clear-color = "f9e2af";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "f38ba8";
      text-color = "cdd6f4";
      text-clear-color = "f9e2af";
      text-ver-color = "89b4fa";
      text-wrong-color = "f38ba8";
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
    };
    timeouts = [
      {
        timeout = 3600;
        command = "systemctl suspend";
      }
    ];
  };

  services.easyeffects.enable = true;

  # Config symlinks
  xdg.configFile."i3blocks/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nixos/dotfiles/i3blocks/config";
  xdg.configFile."mako/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nixos/dotfiles/mako/config";
}
