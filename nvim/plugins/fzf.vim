nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>x :Commands<CR>
nnoremap <Leader>l :Explore<CR>
nnoremap <Leader>p :GFiles<CR>
nnoremap <Leader>g :GFiles?<CR>
nnoremap <Leader>f :Ag<CR>
nnoremap <Leader>k :bd<CR>

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

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

