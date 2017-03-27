" Author: Hongbo Liu <hbliu@freewheel.tv>
" Date: 2017-03-27

let s:vcs_folder = [g:tags4proj_cusproj, '.git', '.hg', '.svn', '.bzr', '_darcs']

let g:project_config_filename = "project_conf.vim"

func! FindProjectRoot() abort
	let s:searchdir = [expand('%:p:h'), getcwd()]

    let vsc_dir = ''
	for d in s:searchdir
		for vcs in s:vcs_folder
			let vsc_dir = finddir(vcs, d .';')
			if !empty(vsc_dir) | break | endif
		endfor
		if !empty(vsc_dir) | break | endif
    endfo

    " let root = fnamemodify(vsc_dir, ':p')

    return vsc_dir
endf

function! OpenProjectConfigFile()
	let project_root = FindProjectRoot()
	execute("new " .project_root. "/" .g:project_config_filename)
endfunction

command! -nargs=0 ProjectConfig call OpenProjectConfigFile()
