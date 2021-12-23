" Author: Hongbo Liu <hbliu@freewheel.tv>
" Date: 2017-03-27

let g:project_config_filename = 'project_conf.vim'

let s:vcs_folder = [
      \ g:project_config_filename,
      \ '.proj', 'BLADE_ROOT',
      \ '.git', '.hg', '.svn', '.bzr', '_darcs',
      \ ]
let s:root = ''

func! FindProjectRoot() abort
  let s:searchdir = [$ORIG_PWD, expand('%:p:h'), getcwd()]

  let vsc_dir = ''
  for d in s:searchdir
    for vcs in s:vcs_folder
      let vsc_dir = finddir(vcs, d .';')
      if empty(vsc_dir)
        let vsc_dir = findfile(vcs, d .';')
        if !empty(vsc_dir)
          let vsc_dir = fnamemodify(vsc_dir, ':p:h')
          if isdirectory(vsc_dir . '/.svn')
            let vsc_dir = vsc_dir . '/.svn'
          endif
        endif
      endif
      if !empty(vsc_dir) | break | endif
    endfor
    if !empty(vsc_dir) | break | endif
  endfo

  return fnamemodify(vsc_dir, ':p')
endf

function! GetProjectConfigFilePath()
  let l:root = FindProjectRoot()
  let s:root = l:root

  let l:possible_files = [
        \ l:root . '../.' . g:project_config_filename,
        \ l:root .'../'. g:project_config_filename,
        \ l:root .'.'. g:project_config_filename,
        \ l:root . g:project_config_filename
        \ ]

  for l:file in l:possible_files
    if filereadable(l:file)
      return fnamemodify(l:file, ':p')
    endif
  endfor

  return fnamemodify(l:root . g:project_config_filename, ':p')
endfunction

function! OpenProjectConfigFile()
  execute('new ' .GetProjectConfigFilePath())
endfunction

function! LoadProjectConfig()
  let l:config_file = GetProjectConfigFilePath()
  let g:project_root = '/' . join(split(s:root, '/')[0:-2], '/')

  if filereadable(l:config_file)
    execute('source ' .l:config_file)
  endif
endfunction

augroup ProjectConfig
  autocmd VimEnter * call LoadProjectConfig()
augroup END

if !exists('g:project_push_excludes')
  let g:project_push_excludes = ['\.git']
endif

execute('autocmd BufWritePost ' .GetProjectConfigFilePath(). ' call LoadProjectConfig()')

command! -nargs=0 ProjectConfig call OpenProjectConfigFile()
command! -nargs=* Ppush call project_push#execute(<f-args>)
