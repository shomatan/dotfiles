set laststatus=2
set noshowmode

function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

function! CocGitStatus()
  return get(g:, 'coc_git_status', '')
endfunction

" Show full path of filename
function! FilenameWithPath()
    return expand('%')
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
  \   'gitstatus': 'CocGitStatus',
  \   'filename': 'FilenameWithPath'
  \ },
  \ }
