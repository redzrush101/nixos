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
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "│";
        };
        soft-wrap.enable = true;
        bufferline = "multiple";
        statusline = {
          left = ["mode" "spinner" "file-name" "file-modification-indicator"];
          center = [];
          right = ["diagnostics" "selections" "position" "file-encoding"];
        };
      };
      keys.normal = {
        space.space = "file_picker";
        space.f = "file_picker";
        space.b = "buffer_picker";
      };
    };
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
      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
      directory.style = "bold lavender";
      git_branch.style = "bold mauve";
      git_status.style = "bold red";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
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
