syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
" set autochdir
set history=4096
set nobackup
set noswapfile
set autoread
set autowrite
set whichwrap+=<,>,[,] " https://stackoverflow.com/a/2574203
set backspace=indent,eol,start " same as above

" Ident
set autoindent
set smartindent
set smarttab
set shiftround
set expandtab
set shiftwidth=4
set tabstop=4

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
set magic

" UI
set mouse=a
set cursorline
set nowrap
set novisualbell
set noerrorbells
set termguicolors
" colorscheme gruvbox
colorscheme zenbones
set list
set showbreak=↪\
set listchars=tab:→\ ,extends:›,precedes:‹,nbsp:␣,trail:·
" set number
set showcmd

" Keymap
let mapleader=" "
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>P "+P
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
