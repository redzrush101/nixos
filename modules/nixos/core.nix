{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ===== BOOT =====
  # Bootloader with Lanzaboote for Secure Boot
  boot.loader.systemd-boot.enable = lib.mkForce false; # Disabled for Lanzaboote
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ===== NIX SETTINGS =====
  nix.settings = {
    # Enable flakes
    experimental-features = [ "nix-command" "flakes" ];

    # Auto-optimise store
    auto-optimise-store = true;

    # Binary caches
    substituters = [
      "https://cache.nixos.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPSQPHZdBs8CIs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  # Automatic store optimization
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Run daily at 03:45

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ===== LOCALE =====
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
}
