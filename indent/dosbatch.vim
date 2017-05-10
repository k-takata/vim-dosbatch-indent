" Vim indent file
" Language:	MSDOS batch file (with NT command extensions)
" Maintainer:	Ken Takata
" URL:		https://github.com/k-takata/vim-dosbatch-indent
" Last Change:	2017 May 10
" Filenames:	*.bat
" License:	VIM License

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent
setlocal noautoindent
setlocal indentexpr=GetDosBatchIndent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal indentkeys+=0=)

if exists("*GetDosBatchIndent")
  finish
endif

function! GetDosBatchIndent(lnum)
  let l:prevlnum = prevnonblank(a:lnum-1)
  if l:prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let l:prevl = substitute(getline(l:prevlnum), '\c^@\?rem\>.*$', '', '')
  let l:thisl = getline(a:lnum)
  let l:previ = indent(l:prevlnum)

  let l:ind = l:previ

  if l:prevl =~? '^\s*if\>.*(' ||
	\ l:prevl =~? '\<do\>\s*(' ||
	\ l:prevl =~? '\<else\>\s*\%(if\>.*\)\?('
    " previous line opened a block
    let l:ind += shiftwidth()
  endif
  if l:thisl =~ '^\s*)'
    " this line closed a block
    let l:ind -= shiftwidth()
  endif

  return l:ind
endfunction

" vim: ts=8 sw=2 sts=2
