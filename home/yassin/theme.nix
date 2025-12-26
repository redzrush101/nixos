{
  config,
  pkgs,
  lib,
  ...
}:

{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Default Apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "macOS";
    package = pkgs.apple-cursor;
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
