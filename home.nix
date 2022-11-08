{ config, pkgs, lib, ... }:
with lib;

let cfg = config.home.my;
in {
  imports = [ ./neovim.nix ./zsh.nix ];

  options = {
    home.my = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      gui = mkOption {
        type = types.bool;
        default = false;
      };
      development = mkOption {
        type = types.bool;
        default = false;
      };
      entertainment = mkOption {
        type = types.bool;
        default = false;
      };
      lite = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    # https://nix-community.github.io/home-manager/options.html
    services.vscode-server.enable = true;

    home.packages = with pkgs;
      let
        basic = [ ripgrep fd btop du-dust python3 tealdeer ];
        gui = optionals cfg.gui [ google-chrome firefox ];
        entertainment = optionals cfg.entertainment [ yt-dlp you-get ];
        development = optionals cfg.development [
          gojq
          shellcheck
          rustup
          python3
          nil
          nixfmt
          hut
          dprint
        ];
      in basic ++ gui ++ development ++ entertainment;

    programs.exa = {
      enable = true;
      enableAliases = true;
    };

    programs.tmux = {
      enable = true;
      clock24 = true;
      prefix = "`";
      extraConfig = ''
        set -g mouse on
      '';
      plugins = with pkgs.tmuxPlugins; [ gruvbox ];
    };

    programs.git = {
      enable = true;
      difftastic.enable = true;
      ignores = [ ".DS_Store" ];
      extraConfig = {
        init = { defaultBranch = "master"; };
        push = { autoSetupRemote = true; };
      };

      aliases = {
        a = "add .";
        ci = "commit -S";
        cia = "commit -S --amend";
        co = "checkout";
        st = "status";
        br = "branch";
        sw = "switch";
        re = "rebase -i HEAD~10";
        lg =
          "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };

    programs.direnv = {
      enable = cfg.development;
      nix-direnv.enable = true;
    };

    programs.helix = { enable = cfg.development; };

    programs.bat.enable = !cfg.lite;

    programs.zoxide.enable = true;

    # fzf https://github.com/junegunn/fzf#fzf-tmux-script
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      tmux.enableShellIntegration = true;
    };

    programs.alacritty = mkIf cfg.gui {
      enable = true;
      # https://github.com/alacritty/alacritty/blob/master/alacritty.yml
      settings = {
        window = { padding = { x = 6; }; };
        font.normal.family = "IBM Plex Mono";
      };
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

}
