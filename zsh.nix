{ pkgs, config, lib, ... }:
let cfg = config.home.my;
in {
  imports = [ ./prompt.nix ];
  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    # https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history.path = "$HOME/.config/zsh/.zsh_history";
    shellAliases = {
      doco = "docker-compose";
      switch = "sudo nixos-rebuild switch --flake";
      sys = "systemctl";
      jou = "journalctl";
    };
    initExtraFirst = lib.mkIf cfg.lite ''
      autoload -Uz promptinit
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
}
