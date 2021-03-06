"" General
set number
set linebreak
set showbreak=+++
set textwidth=120
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2

set ruler
" set relativenumber

set undolevels=1000
set backspace=indent,eol,start

set clipboard+=unnamedplus

syntax on 

let mapleader = "\<space>"

nnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>q :wq<CR>
nnoremap <silent> <leader><ESC> :q<CR>

nmap s- :split<Return><C-w>w
nmap s<Bar> :vsplit<Return><C-w>w

nmap <space> <C-w>w
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

" change width
" nmap <C-w>H <C-w><
" nmap <C-w>L <C-w>>

nmap <C-w>K <C-w>+
nmap <C-w>J <C-w>-

"" tab
nmap gp gT
nmap gn gt
nmap <C-n> :tabe<CR>

"" comment
nmap <C-_> gcc
vmap <C-_> gc


"" Highlight
nnoremap <ESC><ESC> :nohlsearch<CR><ESC>

"" replace
nnoremap <Leader>r :%s///gc<Left><Left><Left><Left>

"" Backup
set nowritebackup
set nobackup
set noswapfile


"" move
noremap 1 0
noremap 2 $

" GUI options
set guioptions+=a


"" Plugins
call plug#begin('~/.local/share/nvim/plugged')

  Plug 'sainnhe/edge'
  Plug 'itchyny/lightline.vim'

  Plug 'sheerun/vim-polyglot'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-commentary'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  if has('nvim')
    Plug 'Shougo/defx.nvim', {'do': ':UpdateRemotePlugins'}
  else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'kristijanhusak/defx-icons'
  Plug 'ryanoasis/vim-devicons'

  " git
  Plug 'kristijanhusak/defx-git'
  Plug 'tpope/vim-fugitive'

  " fzf
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

call plug#end()

"" coc.nvim
let g:coc_global_extensions = [
  \ 'coc-angular',
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-go',
  \ 'coc-java',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-lists',
  \ 'coc-marketplace',
  \ 'coc-metals',
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-rls',
  \ 'coc-rome',
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-vimlsp',
  \ 'coc-yaml'
  \ ]

" load config from plugins directory
runtime! plugins/*.vim
