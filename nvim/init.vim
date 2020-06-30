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

"" Plugins
call plug#begin('~/.local/share/nvim/plugged')

  Plug 'sainnhe/edge'
  Plug 'itchyny/lightline.vim'

  Plug 'sheerun/vim-polyglot'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-commentary'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-denite', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  if has('nvim')
    Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'Shougo/defx.nvim', {'do': ':UpdateRemotePlugins'}
  else
    Plug 'Shougo/denite.nvim'
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'kristijanhusak/defx-icons'
  Plug 'ryanoasis/vim-devicons'

  " git
  Plug 'kristijanhusak/defx-git'
  Plug 'tpope/vim-fugitive'

  Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}

call plug#end()


" load config from plugins directory
runtime! plugins/*.vim


"" Defx.nvim
nnoremap <silent> sf :<C-u>Defx -listed -resume -buffer-name=tab`tabpagenr()`<CR>

call defx#custom#option('_', {
  \ 'winwidth': 40,
  \ 'split': 'vertical',
  \ 'direction': 'topleft',
  \ 'show_ignored_files': 1,
  \ 'buffer_name': 'exproler',
  \ 'toggle': 1,
  \ 'resume': 1,
  \ 'columns': 'indent:git:icons:filename:mark',
  \ })

function! s:defx_my_mappings()
  " Define mappings
  nnoremap <silent><buffer><expr> <CR> defx#async_action('drop')
  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> m defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> l defx#async_action('open_tree')
  nnoremap <silent><buffer><expr> E defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> P defx#do_action('drop', 'pedit')
  nnoremap <silent><buffer><expr> o defx#async_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> O defx#async_action('open_tree_recursive')
  nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C defx#do_action('toggle_columns', 'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'Time')
  nnoremap <silent><buffer><expr> se defx#do_action('add_session')
  nnoremap <silent><buffer><expr> sl defx#do_action('load_session')
  nnoremap <silent><buffer><expr> d defx#do_action('remove_trash')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> > defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> . defx#do_action('repeat')
  nnoremap <silent><buffer><expr> .. defx#async_action('cd', ['..'])
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> h defx#async_action('close_tree')
  nnoremap <silent><buffer><expr> ~ defx#async_action('cd')
  nnoremap <silent><buffer><expr> \ defx#do_action('cd', getcwd())
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
  xnoremap <silent><buffer><expr> <CR> defx#do_action('toggle_select_visual')
  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
  nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ? ':<C-u>wincmd w<CR>' : ':<C-u>Defx -buffer-name=temp -split=vertical<CR>'
endfunction

autocmd FileType defx call s:defx_my_mappings()

augroup defx
  au!
  au VimEnter * sil! au! FileExplorer *
  au BufEnter * if s:isdir(expand('%')) | bd | exe 'Defx' | endif
  au BufRead,BufNewFile *.sbt,*.sc set filetype=scala
augroup END

function! s:isdir(dir) abort
  return !empty(a:dir) && (isdirectory(a:dir) ||
     \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
endfunction

"" lightline.vim
set laststatus=2
set noshowmode

function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

function! CocGitStatus()
  return get(g:, 'coc_git_status', '')
endfunction

let g:lightline = {
  \ 'colorscheme': 'edge',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitstatus', 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction',
  \   'gitstatus': 'CocGitStatus'
  \ },
  \ }

"" coc.nvim
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
map <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" scala
autocmd FileType json syntax match Comment +\/\/.\+$+

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,scala setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" 【Ctrl + d + a】 カレントディレクトリとバッファを表示
nnoremap <silent><C-d>a :<C-u>Denite file buffer -split=floating file:new<CR>
" 【Ctrl + d + b】 バッファを表示
nnoremap <silent><C-d>b :<C-u>Denite buffer -split=floating file:new<CR>
" 【Ctrl + d + f】 カレントディレクトリを表示
"nnoremap <silent><C-d>f :<C-u>Denite file -split=floating file:new<CR>
" 【Ctrl + d + p】 カレントディレクトリ以下を再帰的に表示
nnoremap <silent><C-d>p :<C-u>Denite file/rec -split=floating file:new<CR>
" 【Ctrl + d + f】 カレントディレクトリ以下のファイルから指定した文字列を検索
nnoremap <silent><C-d>f :<C-u>Denite grep -buffer-name=search<CR>
" 【Ctrl + d + ,】 カレントディレクトリ以下のファイルからカーソル下の文字列を検索
nnoremap <silent><C-d>, :<C-u>DeniteCursorWord grep -buffer-name=search line<CR>
" 【Ctrl + d + gs】 grepした結果を再表示
nnoremap <silent><C-d>gs :<C-u>Denite -resume -buffer-name=search<CR>
" 【Ctrl + d + c】 Neovim内で実行したコマンドを表示
"nnoremap <silent><C-d>c :<C-u>Denite command_history -split=floating<CR>

nnoremap <silent><C-d>c :<C-u>Denite coc-command -split=floating<CR>

call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  " 【o】 ファイルを開く
  nnoremap <silent><buffer><expr> o
  \ denite#do_map('do_action')
  " 【s】 ウィンドウを水平分割してファイルを開く
  nnoremap <silent><buffer><expr> s
  \ denite#do_map('do_action', 'split')
  " 【v】 ウィンドウを垂直分割してファイルを開く
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  " 【d】 ファイルを削除する
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  " 【p】 ファイルをプレビュー画面で開く
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  " 【ESC】 / 【q】 denite.nvimを終了する
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  " 【i】 ファイル名で検索する
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  " 【SPACE】 ファイルを複数選択する
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

call denite#custom#var('file/rec', 'command',
\ ['rg', '--files', '--glob', '!.git', '--color', 'never'])
call denite#custom#var('grep', {
\ 'command': ['rg'],
\ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
\ 'recursive_opts': [],
\ 'pattern_opt': ['--regexp'],
\ 'separator': ['--'],
\ 'final_opts': [],
\ })

