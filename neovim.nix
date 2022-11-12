{ pkgs, config, lib, ... }:
with pkgs.vimPlugins;
let
  readFile = builtins.readFile;
  cfg = config.home.my;
  ifExtra = lib.optionals (!cfg.lite);
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
  plugins = {
    basic = [
      {
        # https://github.com/lewis6991/impatient.nvim
        plugin = impatient-nvim;
        type = "lua";
        config = "require('impatient')";
      }
      plenary-nvim
    ];
    editor = {
      basic = [
        vim-surround
        # {
        #   # https://github.com/machakann/vim-sandwich/
        #   plugin = vim-sandwich;
        # }
        vim-repeat
        vim-nix
        {
          # https://github.com/folke/which-key.nvim/
          plugin = which-key-nvim;
          type = "lua";
          config = readFile ./neovim/which-key.lua;
        }
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
        nvim-autopairs
        editorconfig-vim
        {
          plugin = vim-commentary;
          type = "vim";
          config = readFile ./neovim/commentary.vim;
        }
      ];
      extra = ifExtra [
        vim-sleuth # Heuristically set buffer options
      ];
    };
    ui = {
      basic = [ gruvbox indent-blankline-nvim-lua ];
      extra = ifExtra [
        edge
        vim-smoothie
        neovim-beacon
        {
          # https://github.com/RRethy/vim-illuminate/
          plugin = vim-illuminate;
        }
        {
          # Status Line
          # https://github.com/feline-nvim/feline.nvim
          plugin = feline-nvim;
          type = "lua";
          config = readFile ./neovim/feline.lua;
        }
      ];
    };
  };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = builtins.readFile ./config.vim;
    plugins = plugins.basic ++ plugins.editor.basic ++ plugins.editor.extra
      ++ plugins.ui.basic ++ plugins.ui.extra;
  };
}
