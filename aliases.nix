{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.home.my;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  common = { "@" = "cd $(git rev-parse --show-toplevel)/"; };
  linuxAliases = optionalAttrs isLinux {
    doco = "docker-compose";
    switch = "sudo nixos-rebuild switch --flake";
    sys = "systemctl";
    jou = "journalctl";
  };
  darwinAliases =
    optionalAttrs isDarwin { switch-home = "home-manager switch --flake"; };
  shellAliases = common // linuxAliases // darwinAliases;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = shellAliases;
    programs.bash.shellAliases = shellAliases;
  };
}
