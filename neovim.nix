{ pkgs, config, lib, ... }:
let
  cfg = config.home.my;
  vim-chinese-document = pkgs.vimUtils.buildVimPlugin {
    name = "vimcdoc";
    pname = "vimcdoc";
    src = pkgs.fetchFromGitHub {
      owner = "yianwillis";
      repo = "vimcdoc";
      rev = "c0d3edb1de4bd83df08e99c5f63393069a17f066";
      sha256 = "blUAz0JDG6ts5WLDogHMTdnE/RgUu9QEeeT9xjm3TJI=";
    };
  };
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
  basicPlugins = with pkgs.vimPlugins; [
    vim-surround
    nvim-autopairs
    editorconfig-vim
    vim-surround
    vim-repeat
    vim-sleuth
    vim-nix
    vim-commentary
  ];
  extraPlugins = with pkgs.vimPlugins;
    lib.optionals (!cfg.lite) [
      vim-airline
      vim-airline-themes
      vim-chinese-document
      gruvbox
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
