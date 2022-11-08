{
  description = "My Home-Manager module";
  outputs = { self, ... }: {
    nixosModules.home = self.homeModule;
    homeModule = import ./home.nix;
  };
}
