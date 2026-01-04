{ config, pkgs, ... }:

{
  # Zsh System-wide
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable dconf for Home Manager/GTK apps
  programs.dconf.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    sbctl # For Secure Boot
    # Desktop Apps
    firefox
    thunar
    # Utils
    libnotify # For notify-send
    sysstat # For i3blocks cpu/mem
    jq
    xdg-utils
    file
    python3
    iflow-cli
    openspec
    multipath-tools
    openssl
    util-linux
    btop

    # Android Mainlining Tools
    android-tools
    binwalk
    lz4
    dtc
    gnumake
    gcc
    bison
    flex
    bc
  ];

  # Services
  services.iloader.enable = true;
}
