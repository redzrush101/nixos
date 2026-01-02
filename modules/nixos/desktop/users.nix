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
      pkgs.llm-agents.claude-code-router
      pkgs.llm-agents.droid
      pkgs.llm-agents.cursor-agent
      pkgs.llm-agents.opencode
      pkgs.llm-agents.openspec

    ];
  };

  # Autologin on TTY1
  services.getty.autologinUser = "yassin";
}
