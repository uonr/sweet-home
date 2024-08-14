{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.sweet;
in
lib.mkIf cfg.enable {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    difftastic.enable = cfg.level == "extra";
    ignores = [
      ".DS_Store"
      ".direnv"
    ];
    extraConfig = {
      # https://jvns.ca/blog/2024/02/16/popular-git-config-options/
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      pull.ff = "only";
      rebase.autostash = true;
      help.autocorrect = 10;
      merge.tool = "vscode";
      diff.tool = "nvimdiff";
      diff.guitool = "vscode";
      "mergetool \"vscode\"".cmd = "code --wait --merge $REMOTE $LOCAL $BASE $MERGED";
      "difftool \"vscode\"".cmd = "code --wait --diff $LOCAL $REMOTE";
      "difftool \"difftastic\"".cmd = "${pkgs.difftastic}/bin/difft $LOCAL $REMOTE";
    };

    aliases = {
      a = "add .";
      c = "commit";
      ca = "commit --amend";
      caa = "commit --all --amend";
      cl = "clone --recurse-submodules";
      co = "checkout";
      ps = "push";
      pl = "pull --rebase --prune";
      st = "status";
      br = "branch";
      sw = "switch";
      s = "commit -m '[WIP] A tempereary commit, should be squashed later'";
      sa = "s -a";
      re = "rebase -i HEAD~10";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      vidiff = "difftool --tool nvimdiff";
      vsdiff = "difftool --tool vscode";
      difft = "difftool --tool difftastic";
    };
  };
}
