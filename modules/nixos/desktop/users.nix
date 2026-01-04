{
  config,
  pkgs,
  inputs,
  ...
}:

{
  users.users.yassin = {
    isNormalUser = true;
    description = "Yassin Rezai";
    extraGroups = [
      "wheel"
      "podman"
      "adbusers"
      "plugdev"
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
