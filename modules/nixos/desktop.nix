{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # ===== SHELL =====
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable dconf for Home Manager/GTK apps
  programs.dconf.enable = true;

  # ===== SYSTEM PACKAGES =====
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

  # ===== USERS =====
  users.users.yassin = {
    isNormalUser = true;
    description = "Yassin Rezai";
    extraGroups = [
      "wheel"
      "podman"
      "adbusers"
      "plugdev"
      "video"
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    linger = true;
    packages = with pkgs; [
      antigravity
      inetutils
      android-tools
      vscode
      discord
      gh
      glab
      neovim
      fastfetch
      claude-code
      mtkclient
      bun
      unzip
      pkgs.llm-agents.claude-code-router
      pkgs.llm-agents.droid
      pkgs.llm-agents.cursor-agent
      pkgs.llm-agents.opencode

    ];
  };

  users.groups.plugdev = { };

  # Autologin on TTY1
  services.getty.autologinUser = "yassin";
}
