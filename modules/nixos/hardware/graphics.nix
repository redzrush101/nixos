{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Graphics
  hardware.graphics = {
    enable = true;
  };

  # DBus
  services.dbus.enable = true;

  # Thumbnailer service
  services.tumbler.enable = true;

  # Polkit
  security.polkit.enable = true;

  # Link libexec for polkit agents
  environment.pathsToLink = [ "/libexec" ];

  # Scroll Window Manager
  environment.systemPackages = [
    inputs.scroll-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.kitty # Terminal for initial usage
    pkgs.polkit_gnome
    pkgs.wmenu # Required by xdg-desktop-portal-wlr for output chooser
    pkgs.slurp # Region selector for screen capture
  ];

  environment.sessionVariables = {
    # Tell QT, GDK and others to use the Wayland backend by default
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    # XDG desktop variables to set scroll as the desktop
    XDG_CURRENT_DESKTOP = "scroll";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "scroll";

    # Configure Electron to use Wayland instead of X11
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
      scroll = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
      };
      sway = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
