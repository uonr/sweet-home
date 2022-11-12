{
  description = "My Home-Manager module";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };
  outputs = { self, nixpkgs, ... }: {
    nixosModules.home = self.homeModule;
    homeModule = import ./home.nix;
  };
}
