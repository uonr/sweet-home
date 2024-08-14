{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.home.sweet;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  common = {
    "@" = "cd $(git rev-parse --show-toplevel)/";
    doco = "docker-compose";
    lss = "eza --tree --level=2 --long";
    lsss = "eza --tree --level=4 --long";
    lssss = "eza --tree --level=8 --long";
  };
  linuxAliases = optionalAttrs isLinux {
    sys = "systemctl";
    jou = "journalctl";
  };
  darwinAliases = optionalAttrs isDarwin {
    swhome = "home-manager switch";
    tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
  };
  shellAliases = common // linuxAliases // darwinAliases;
in
{
  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = shellAliases;
    programs.bash.shellAliases = shellAliases;
    programs.fish.shellAliases = shellAliases;
  };
}
