{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    swaylock
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
  ];

  home.file.".config/wallpapers".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nixos/dotfiles/wallpapers";

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
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
