{
  description = "My Home-Manager module";
  outputs = { ... }: { nixosModules.home = import ./home.nix; };
}
