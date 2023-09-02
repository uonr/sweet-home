{
  description = "My Home-Manager module";
  inputs = { };
  outputs = { self, ... }: {
    nixosModule = ({ pkgs, ... }: { imports = [ ./nixos.nix ]; });
    nixosModules.nixos = self.nixosModule;
    homeModule = import ./home.nix;
  };
}
