" Copyright (c) 2019, Tencent Inc
" Author: Hongbo Liu <hongboliu@tencent.com>
" Date  : 2019-11-18 23:57:39

" function! project_push#execute(cmd, host, remote_dir)
function! project_push#execute(...)
  if a:0 > 3
    echoerr "At most 3 parameters"
    return
  endif

  let l:cmd = 'scp'
  let l:host = ''
  let l:remote_dir = ''

  if exists('g:project_push_cmd')
    let l:cmd = g:project_push_cmd
  endif

  if exists('g:project_push_host')
    let l:host = g:project_push_host
  endif

  if exists('g:project_push_remote_dir')
    let l:remote_dir = g:project_push_remote_dir
  endif

  if a:0 == 3
    let l:cmd = a:1
    let l:host = a:2
    let l:remote_dir = a:3
  endif

  if !exists('g:project_root')
    echoerr 'No g:project_root defined!'
    return
  endif

  let l:filepath = expand('%:p')
  if match(l:filepath, g:project_root) < 0
    return
  endif

  let l:project_file = substitute(l:filepath, g:project_root, '', '')
  for l:exclude in g:project_push_excludes
    if match(l:project_file, l:exclude) >= 0
      return
    endif
  endfor

  execute(printf('Dispatch! %s %s %s:%s%s',
        \ l:cmd, l:filepath, l:host, l:remote_dir, l:project_file))
endfunction
