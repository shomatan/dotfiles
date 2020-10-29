nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Ag<CR>
nnoremap <Leader>g :GFiles?<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>l :Explore<CR>
nnoremap <Leader>p :GFiles<CR>
nnoremap <Leader>x :Commands<CR>

" Most Recently Used
nnoremap <Leader>r :FZFMru<CR>

" New window
let g:fzf_layout = { 'window': 'enew' }

" New tab
let g:fzf_layout = { 'window': '-tabnew' }

command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

