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
      android-tools
      vscode
      discord
      gh
      glab
      neovim
      fastfetch
      claude-code
      mtkclient
      inputs.llm-agents.packages.x86_64-linux.claude-code-router
      inputs.llm-agents.packages.x86_64-linux.opencode
      inputs.llm-agents.packages.x86_64-linux.droid
      inputs.llm-agents.packages.x86_64-linux.cursor-agent
    ];
  };

  # Autologin on TTY1
  services.getty.autologinUser = "yassin";
}
