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

call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action', 'tabopen')
  " 【o】 ファイルを開く
  nnoremap <silent><buffer><expr> o denite#do_map('do_action')
  " 【s】 ウィンドウを水平分割してファイルを開く
  nnoremap <silent><buffer><expr> s denite#do_map('do_action', 'split')
  " 【v】 ウィンドウを垂直分割してファイルを開く
  nnoremap <silent><buffer><expr> v denite#do_map('do_action', 'vsplit')
  " 【d】 ファイルを削除する
  nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
  " 【p】 ファイルをプレビュー画面で開く
  nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
  " 【ESC】 / 【q】 denite.nvimを終了する
  nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> q denite#do_map('quit')
  " 【i】 ファイル名で検索する
  nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
  " 【SPACE】 ファイルを複数選択する
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
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

