{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.home.sweet;
in
{
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
    level = mkOption {
      type = types.enum [
        "minimal"
        "normal"
        "extra"
      ];
      default = "normal";
    };
    options.programs.wezterm = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  imports = [
    ./zsh.nix
    ./git.nix
    ./aliases.nix
    ./neovim
  ];
  config = lib.mkIf cfg.enable {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = lib.mkDefault "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages =
      with pkgs;
      let
        basic = [
          ripgrep
          fd
          htop
        ];
        common = lib.optionals (cfg.level != "minimal") [
          nil
          nixfmt-rfc-style
          nixpkgs-fmt
        ];
        extra = lib.optionals (cfg.level == "extra") [
          hut
          jujutsu
          yt-dlp
          shellcheck
          btop
          du-dust
          dua
          tealdeer
          yazi
        ];
        nerdfonts = lib.optionals cfg.fonts.nerd (
          with nerd-fonts;
          [
            fantasque-sans-mono
            fira-code
            droid-sans-mono
            blex-mono
            iosevka
            iosevka-term
            intel-one-mono
            jetbrains-mono
            victor-mono
            caskaydia-mono
            go-mono
            space-mono
            hack
            overpass
            lilex
          ]
        );
        fonts = lib.optionals cfg.fonts.normal [
          sarasa-gothic
          iosevka
          ibm-plex
          monaspace
          cascadia-code
          noto-fonts
        ];

      in
      basic
      ++ common
      ++ extra
      ++ nerdfonts
      ++ fonts
      ++ (lib.optional config.programs.wezterm.enable wezterm);

    programs.eza = {
      enable = lib.mkDefault cfg.level != "minimal";
      icons = if cfg.icons then "auto" else "never";
      enableFishIntegration = true;
      enableZshIntegration = true;
      extraOptions = [ "--group-directories-first" ];
    };

    programs.tmux = {
      enable = lib.mkDefault true;
      clock24 = true;
      prefix = "`";
      mouse = true;
      plugins =
        with pkgs.tmuxPlugins;
        let
          theme = lib.optionals (cfg.level != "minimal") [
            {
              plugin = dracula;
              # https://draculatheme.com/tmux
              extraConfig = ''
                set -g @dracula-show-battery false
                set -g @dracula-show-powerline false
                set -g @dracula-refresh-rate 5
                set -g @dracula-show-left-icon session
                set -g @dracula-plugins "ssh-session cpu-usage ram-usage"
              '';
            }
          ];
        in
        theme;
    };

    programs.fish = {
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [ ];
      shellInit = builtins.readFile ./init.fish;
    };

    programs.zoxide.enable = true;

    # fzf https://github.com/junegunn/fzf#fzf-tmux-script
    programs.fzf = {
      enable = lib.mkDefault cfg.level != "minimal";
      defaultCommand = "fd --type f";
      tmux.enableShellIntegration = true;
    };

    programs.alacritty = lib.mkIf config.programs.alacritty.enable {
      # https://github.com/alacritty/alacritty/blob/master/alacritty.yml
      settings = {
        window = {
          padding = {
            x = 6;
          };
        };
        font.size = 14.0;
        font.normal.family = "BlexMono Nerd Font Mono";
      };
    };

    programs.helix = lib.mkIf config.programs.helix.enable {
      settings = {
        theme = "spacebones_light";
      };
    };

    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
    xdg.configFile."wezterm/shell.lua".text = ''
      return { "${lib.getExe config.programs.fish.package}", "-l" }
    '';

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
