" Author: Hongbo Liu <hbliu@freewheel.tv>
" Date: 2017-03-27

let s:vcs_folder = ['BLADE_ROOT', '.proj', '.git', '.hg', '.svn', '.bzr', '_darcs']

let g:project_config_filename = "project_conf.vim"

func! FindProjectRoot() abort
    let s:searchdir = [expand('%:p:h'), getcwd()]

    let vsc_dir = ''
    for d in s:searchdir
        for vcs in s:vcs_folder
            let vsc_dir = finddir(vcs, d .';')
            if empty(vsc_dir)
                let vsc_dir = findfile(vcs, d .';')
                if !empty(vsc_dir)
                    let vsc_dir = fnamemodify(vsc_dir, ":p:h")
                    if isdirectory(vsc_dir . "/.svn")
                        let vsc_dir = vsc_dir . "/.svn"
                    endif
                endif
            endif
            if !empty(vsc_dir) | break | endif
        endfor
        if !empty(vsc_dir) | break | endif
    endfo

    return fnamemodify(vsc_dir, ":p")
endf

function! GetProjectConfigFilePath()
    let root = FindProjectRoot()
    let possible_files = [
                \ root . '../.' . g:project_config_filename,
                \ root .'../'. g:project_config_filename,
                \ root .'.'. g:project_config_filename,
                \ root . g:project_config_filename
                \ ]

    for file in possible_files
        if filereadable(file)
            return fnamemodify(file, ":p")
        endif
    endfor

    return fnamemodify(root . g:project_config_filename, ":p")
endfunction

function! OpenProjectConfigFile()
    execute("new " .GetProjectConfigFilePath())
endfunction

function! LoadProjectConfig()
    let config_file = GetProjectConfigFilePath()
    if filereadable(config_file)
        let g:project_root = "/" . join(split(config_file, '/')[0:-3], '/')
        execute("source " .config_file)
    endif
endfunction

autocmd VimEnter * call LoadProjectConfig()

execute("autocmd BufWritePost " .GetProjectConfigFilePath(). " call LoadProjectConfig()")

command! -nargs=0 ProjectConfig call OpenProjectConfigFile()
