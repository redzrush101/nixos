{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.kitty = {
    enable = true;
    # Theme symlinked
  };
  xdg.configFile."kitty/kitty.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nixos/dotfiles/kitty/kitty.conf";

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
    };
  };

  # Link Helix runtime (themes/grammars) to ~/.local/share/helix/runtime
  # This makes themes available to the Ubuntu Distrobox container
  home.file.".local/share/helix/runtime".source = "${pkgs.helix}/lib/runtime";

  home.sessionVariables = {
    HELIX_RUNTIME = "${config.home.homeDirectory}/.local/share/helix/runtime";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake .";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"
      export NIX_CONFIG="access-tokens = github.com=$(gh auth token)"
    '';

    loginExtra = ''
      if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
        exec scroll
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
      };
      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
    };
  };

  services.mako = {
    enable = true;
    # Config symlinked
  };
}
