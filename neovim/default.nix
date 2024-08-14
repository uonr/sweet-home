{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs.vimPlugins;
let
  readFile = builtins.readFile;
  cfg = config.home.sweet;
  filter = {
    common = lib.optionals (cfg.level != "minimal");
    extra = lib.optionals (cfg.level == "extra");
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
  numbers-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "numbers-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nkakouros-original";
      repo = "numbers.nvim";
      rev = "d1f95879a4cdf339f59e6a2dc6aef26912cf554c";
      sha256 = "eB0G1PUyS9Q6Jv7mku+SW9PCPnoUYz7HRhed38hxskw=";
    };
  };
  plugins = {
    minimal = [ ];
    common = filter.common [ plenary-nvim ];
    extra = [
      {
        plugin = neogit;
        type = "lua";
        config = ''
          local neogit = require('neogit')
          neogit.setup {}
        '';
      }
      diffview-nvim
      telescope-nvim
    ];
    editor = {
      minimal = [
        vim-surround
        nvim-autopairs
      ];
      common = filter.common [
        nvim-autopairs
        comment-nvim
        numbers-nvim
        {
          # Motion improvement
          # https://github.com/ggandor/leap.nvim
          plugin = leap-nvim;
          type = "lua";
          config = ''
            require('leap').add_default_mappings()
          '';
        }
        {
          # f/F/t/T improvement
          # https://github.com/ggandor/flit.nvim
          plugin = flit-nvim;
          type = "lua";
          config = "require('flit').setup()";
        }
      ];
      extra = filter.extra [
        vim-sleuth # Heuristically set buffer options
      ];
    };
    ui = {
      minimal = [ ];
      common = filter.common [
        gruvbox
        indent-blankline-nvim-lua
        lush-nvim
        zenbones-nvim
      ];
      extra = filter.extra [
        edge
        vim-smoothie
        neovim-beacon
        {
          # https://github.com/RRethy/vim-illuminate/
          plugin = vim-illuminate;
        }
      ];
    };
  };
in
lib.mkIf config.programs.neovim.enable {
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = builtins.readFile ./config.vim;
    extraLuaConfig = builtins.readFile ./config.lua;
    plugins =
      plugins.minimal
      ++ plugins.common
      ++ plugins.extra
      ++ plugins.editor.minimal
      ++ plugins.editor.common
      ++ plugins.editor.extra
      ++ plugins.ui.minimal
      ++ plugins.ui.common
      ++ plugins.ui.extra;
  };
}
