{ config, lib, ... }:
let cfg = config.sweet-home;
in {
  imports = [ ];
  options = with lib; {
    sweet-home = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable sweet-home";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    home-manager.sharedModules = [ ./home.nix ];
  };
}
