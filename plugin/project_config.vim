" Author: Hongbo Liu <hbliu@freewheel.tv>
" Date: 2017-03-27

let g:project_config_filename = 'project_conf.vim'

let s:vcs_folder = ['.proj', 'BLADE_ROOT', '.git', '.hg', '.svn', '.bzr', '_darcs', g:project_config_filename]

func! FindProjectRoot() abort
  let s:searchdir = [expand('%:p:h'), getcwd()]

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
  if filereadable(l:config_file)
    let g:project_root = '/' . join(split(l:config_file, '/')[0:-3], '/')
    execute('source ' .l:config_file)
  endif
endfunction

augroup ProjectConfig
  autocmd VimEnter * call LoadProjectConfig()
augroup END

execute('autocmd BufWritePost ' .GetProjectConfigFilePath(). ' call LoadProjectConfig()')

command! -nargs=0 ProjectConfig call OpenProjectConfigFile()
