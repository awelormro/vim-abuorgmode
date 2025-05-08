" vim: set fdm=marker:
" org.vim - VimOrganizer plugin for Vim
" -------------------------------------------------------------
" Version: 0.30
" Maintainer: Herbert Sitz <hesitz@gmail.com>
" Last Change: 2011 Nov 02
"
" Script: http://www.vim.org/scripts/script.php?script_id=3342
" Github page: http://github.com/hsitz/VimOrganizer 
" Copyright: (c) 2010, 2011 by Herbert Sitz
" The VIM LICENSE applies to all files in the
" VimOrganizer plugin.  
" (See the Vim copyright except read "VimOrganizer"
" in places where that copyright refers to "Vim".)
" http://vimdoc.sourceforge.net/htmldoc/uganda.html#license
" No warranty, express or implied.
" *** *** Use At-Your-Own-Risk *** ***

" set indent of text lines beyond heading's left column
" 0 -- have text lines flush with their heading's left col
"

" Only load this indent file when no other was loaded. {{{1
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Some preliminary settings {{{1
setlocal nolisp		" Make sure lisp indenting doesn't supersede us
setlocal autoindent	" indentexpr isn't much help otherwise


setlocal indentexpr=GetOrgIndent(...)
setlocal indentkeys+=<:>,=elif,=except,o,O,*<Return>

let b:undo_indent = "setl ai< inde< indk< lisp<"

" Only define the function once.

" Main fold function {{{1
function GetOrgIndent(...)
  let prevline=line(v:lnum)-1
  let prevlinec=getline(prevline)
  if prevlinec=~'^\*\+'
    echo prevline
    let astercount=len(matchstr(getline('.'), '^\*\+'))+1
    execute 'normal '.astercount.'i '
    let python#GetIndent=astercount
    return astercount
  else
    return 10
    echo prevline
  endif
endfunction




" vim:sw=2
