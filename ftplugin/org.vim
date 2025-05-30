" vim: set fdm=marker:
" echo 1
let b:current_syntax='org'
" setlocal commentstring="/*#%s*"

setlocal comments=fb:*,b:#,fb:-
setlocal commentstring=#\ %s
" Fold method plugin {{{1
function! s:NotCodeBlock(lnum) abort
  return synIDattr(synID(a:lnum, 1, 1), 'name') !=# 'OrgCodeBlock'
endfunction
function! OrgFold() abort
  let line = getline(v:lnum)

  if line =~# '^\*\+ ' && s:NotCodeBlock(v:lnum)
    return ">" . match(line, ' ')
  endif

  let nextline = getline(v:lnum + 1)
  if (line =~ '^.\+$') && (nextline =~ '^=\+$') && s:NotCodeBlock(v:lnum + 1)
    return ">1"
  endif

  if (line =~ '^.\+$') && (nextline =~ '^-\+$') && s:NotCodeBlock(v:lnum + 1)
    return ">2"
  endif

  return "="
endfunction

setlocal tw=75
" setlocal foldexpr=OrgFold()
" setlocal foldmethod=expr
" vim9cmd 'import orgnormal.vim'
