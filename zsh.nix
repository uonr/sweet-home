{ pkgs, config, lib, ... }:
let cfg = config.home.my;
in {
  imports = [ ./prompt.nix ];

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = false;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      # https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
      history.path = "$HOME/.config/zsh/.zsh_history";

      # set prompt
      initExtraFirst = lib.mkIf cfg.lite ''
        autoload -Uz promptinit
        promptinit
        prompt walters
      '';

      initExtra = builtins.readFile ./init.zsh;
      dirHashes = { };
      plugins = with pkgs; [
        {
          name = "you-should-use";
          src = "${zsh-you-should-use}/share/zsh/plugins/you-should-use";
        }
        {
          name = "zsh-autopair";
          file = "autopair.zsh";
          src = "${zsh-autopair}/share/zsh/zsh-autopair";
        }
      ];
    };
  };
}
