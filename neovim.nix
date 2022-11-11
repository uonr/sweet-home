{ pkgs, config, lib, ... }:
with pkgs.vimPlugins;
let
  cfg = config.home.my;
  neovim-beacon = pkgs.vimUtils.buildVimPlugin {
    name = "beacon-nvim";
    pname = "beacon-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "rainbowhxch";
      repo = "beacon.nvim";
      rev = "f44c49fd72217fc2fc065a99fe90d36436dae2f3";
      sha256 = "kcjOLjY/+5p3cYSpWTK8i0u69MhgCvvNVB6zDFHjcjI=";
    };
  };
  basicPlugins = [
    nvim-autopairs
    editorconfig-vim
    vim-surround
    vim-repeat
    vim-sleuth
    vim-nix
    vim-commentary
    gruvbox
  ];
  extraPlugins = lib.optionals (!cfg.lite) [
    vim-airline
    vim-airline-themes
    indent-blankline-nvim-lua
    neovim-beacon
  ];
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = basicPlugins ++ extraPlugins;
  };
}
