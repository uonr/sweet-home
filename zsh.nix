{ config, lib, pkgs, ... }:
let cfg = config.home.sweet;
in lib.mkIf cfg.enable {
  programs.zsh = lib.mkIf config.programs.zsh.enable {
    enableAutosuggestions = false;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    # https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history.path = "$HOME/.config/zsh/.zsh_history";

    # set prompt
    initExtraFirst = lib.mkIf (!config.programs.starship.enable) ''
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

  programs.starship =
    let
      presetsPath =
        if cfg.icons then
          "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"
        else
          "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml";
      preset = builtins.fromTOML (builtins.readFile presetsPath);
    in
    lib.mkIf config.programs.starship.enable {
      settings = preset // { nix_shell = { format = "via $symbol"; }; };
    };
}
