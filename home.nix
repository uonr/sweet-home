{ config, pkgs, lib, ... }:

let cfg = config.home.sweet;
in {
  options.home.sweet = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    fonts = {
      normal = mkOption {
        type = types.bool;
        default = false;
      };
      nerd = mkOption {
        type = types.bool;
        default = false;
      };
    };
    icons = mkOption {
      type = types.bool;
      default = cfg.fonts.nerd;
    };
    small = mkOption {
      type = types.bool;
      default = false;
    };
    maintenance = mkOption {
      type = types.bool;
      default = false;
    };
    crawler = mkOption {
      type = types.bool;
      default = false;
    };
    development = mkOption {
      type = types.bool;
      default = false;
    };
    prompt = mkOption {
      type = types.enum [ "starship" "simple" ];
      default = "simple";
    };
  };
  imports = [ ./zsh.nix ./git.nix ./aliases.nix ];
  config = lib.mkIf cfg.enable {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs;
      let
        basic = [ ripgrep fd htop mosh ];
        development = lib.optionals cfg.development [
          nil
          nixfmt
          nixpkgs-fmt
          hut
          shellcheck
        ];
        maintanence = lib.optionals cfg.maintenance [ btop du-dust tealdeer ];
        crawler = lib.optionals cfg.crawler [ yt-dlp you-get ];
        nerd-fonts = lib.optionals cfg.fonts.nerd [
          (nerdfonts.override {
            # https://github.com/ryanoasis/nerd-fonts#patched-fonts
            fonts = [
              "FantasqueSansMono"
              "FiraCode"
              "DroidSansMono"
              "IBMPlexMono"
              "Iosevka"
              "IosevkaTerm"
              "JetBrainsMono"
              "VictorMono"
            ];
          })
        ];
        fonts =
          lib.optionals cfg.fonts.normal [ sarasa-gothic iosevka ibm-plex ];
      in basic ++ nerd-fonts ++ fonts ++ development ++ maintanence ++ crawler;

    programs.direnv = {
      enable = cfg.development;
      nix-direnv.enable = false;
    };

    programs.exa = {
      enable = true;
      enableAliases = true;
      icons = cfg.icons;
      extraOptions = [ "--group-directories-first" ];
    };

    programs.tmux = {
      enable = true;
      clock24 = true;
      prefix = "`";
      mouse = true;
      plugins = with pkgs.tmuxPlugins;
        [ (if cfg.icons then catppuccin else onedark-theme) ];
    };

    programs.zoxide.enable = true;

    # fzf https://github.com/junegunn/fzf#fzf-tmux-script
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      tmux.enableShellIntegration = true;
    };

    programs.bat.enable = lib.mkDefault (!cfg.small);

    programs.alacritty = lib.mkIf config.programs.alacritty.enable {
      # https://github.com/alacritty/alacritty/blob/master/alacritty.yml
      settings = {
        window = { padding = { x = 6; }; };
        font.size = 14.0;
        font.normal.family = "BlexMono Nerd Font Mono";
      };
    };

    programs.helix = lib.mkIf config.programs.helix.enable {

    };

    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
