" vim: set fdm=marker:

" Searching files commands {{{1 
function! SearchFiles(pattern)
  " Ejecutar la búsqueda y obtener los resultados en una lista de archivos
  let files = []
  for file in split(globpath('.', 'Abuwiki/Orgtests/*'), '\n')
    if filereadable(file) && !isdirectory(file) && system('grep -l '.shellescape(a:pattern).' '.shellescape(file)) =~# '\S'
      call add(files, file)
    endif
  endfor
  " Regresar la lista de archivos que coinciden con la cadena de búsqueda
  echo files
  return files
endfunction

" 1}}}

" Command to create base index files {{{1
fun! CreateIndexfile(pattern)
  let indexedfilesprev = execute('call SearchFiles("' . a:pattern . '")')
  let indexedfiles=split(indexedfilesprev, ',')
  call remove(indexedfiles, 0)
  call remove(indexedfiles, len(indexedfiles)-1)
  execute 'e archivoprueba.org'
  normal G$
  let k=0
  while k<len(indexedfiles)-1
    echo indexedfiles[k]
    .put = indexedfiles[k]
    substitute()
    normal G$
    normal 0
    normal 2dw
    normal $
    normal x
    let k=k+1
  endwhile
  echo indexedfiles
endf

" 1}}}



" let mystring = 'Hello World'

" Eliminar el primer y el último carácter de la cadena
" let mystring = strpart(mystring, 1, len(mystring) - 2)

" echo mystring

" echo 1
