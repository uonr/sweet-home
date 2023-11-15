{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.home.sweet;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  common = {
    "@" = "cd $(git rev-parse --show-toplevel)/";
    doco = "docker-compose";
  };
  linuxAliases = optionalAttrs isLinux {
    switch = "sudo nixos-rebuild switch --flake";
    sys = "systemctl";
    jou = "journalctl";
  };
  darwinAliases = optionalAttrs isDarwin { switch = "home-manager switch"; };
  shellAliases = common // linuxAliases // darwinAliases;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = shellAliases;
    programs.bash.shellAliases = shellAliases;
  };
}
