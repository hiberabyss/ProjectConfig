" Copyright (c) 2019, Tencent Inc
" Author: Hongbo Liu <hongboliu@tencent.com>
" Date  : 2019-11-18 23:57:39

function! project_push#execute(cmd, host, remote_dir)
  if !exists('g:project_root')
    echoerr 'No g:project_root defined!'
    return
  endif

  let l:filepath = expand('%:p')
  if !match(l:filepath, g:project_root) < 0
    return
  endif

  let l:project_file = substitute(l:filepath, fnamemodify(g:project_root, ':h'), '', '')
  for l:exclude in g:project_push_excludes
    if match(l:project_file, l:exclude) >= 0
      return
    endif
  endfor

  execute(printf('Dispatch! %s %s %s:%s%s',
        \ a:cmd, l:filepath, a:host, a:remote_dir, l:project_file))
endfunction
