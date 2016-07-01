" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/dotfiles/vimfiles/bundle')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml = '~/dotfiles/vimfiles/plugins.toml'
  let s:lazy_toml = '~/dotfiles/vimfiles/plugins_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif


" ここに入れたいプラグインを記入
" NeoBundle 'Shougo/unite.vim'          " カラーテーマ一覧
" NeoBundle 'ujihisa/unite-colorscheme'
" NeoBundle 'vim-ref/vim-ref-ri'        " リファレンス
" NeoBundle 'ctags/vim-tags'            " メソッド定義元へのジャンプ


" 補完
" NeoBundle 'Shougo/neocomplete'
" NeoBundle 'Shougo/neosnippet'
" NeoBundle 'Shougo/neosnippet-snippets'
" NeoBundle 'violetyk/neocomplete-php.vim'

filetype plugin indent on

" 行番号を表示
set number

" カラー表示
set background=dark
let g:hybrid_use_iTerm_colors = 1
set rtp+=~/.vim/bundle/vim-hybrid
colorscheme hybrid
syntax enable

" Tabをスペース4つに展開
set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

" auto comment off
augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END

" カーソルラインを表示
set cursorline

" NERDTreeのショートカット
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

map <C-l> gt
map <C-h> gT

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
set conceallevel=2 concealcursor=niv
endif

" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
autocmd VimEnter * execute 'NERDTree'
