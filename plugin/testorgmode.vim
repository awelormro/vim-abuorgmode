" vim: set fdm=marker:

" New function with list {{{1
" Obtain info from data {{{2
function! ConvertToFormat(format)
  let data=split(a:format, ' ')
  let input_filetype='org'
  let output_filetype=data[0]
  let optargs = Tail(data)
  " echo optargs
  let optionals = join(optargs, ' ')
  " echo optionals Output selection, needing input and output {{{2
  if output_filetype=='beamer'
    let file_extension='pdf'
  elseif output_filetype=='beamertex'
    let file_extension='tex'
    let output_filetype='beamer'
  else
    let file_extension = output_filetype
  endif
  let input_file = expand('%')
  " echo input_file
  " Command to output {{{2
  let output_file = substitute(input_file, '\.org$', '.' . file_extension, '')
  echo output_file
  let command = 'pandoc -f ' . input_filetype . ' -t ' . output_filetype . ' '  . input_file . ' -o ' . output_file .  ' ' . optionals
  " echo command
  call system(command)
  echo 'Completed'
  " redraw!
endfunction


function! CompleteFormat(A, L, P)
  if !exists("s:formats")
    let s:formats = ["docx", "html", "markdown", "tex", "org", 'powerpoint', 'rtf', 'revealjs', 'beamertex']
  endif
  return filter(s:formats, 'v:val =~ "^" . a:A')
endfunction


function! Tail(list)
  return a:list[1:]
endfunction

command! -nargs=* -complete=customlist,CompleteFormat OrgConvertToFormat call ConvertToFormat(<q-args>)
" Reassign ctags incorporation {{{1
" let g:tagbar_type_org = {
"       \   'ctagstype':'org'
"       \ , 'kinds':['h:header']
"       \ , 'sro':'&&&'
"       \ , 'kind2scope':{'h':'header'}
"       \ , 'sort':0
"       \ , 'ctagsbin':'~/.vimconfigs/orgmodetags.py'
"       \ , 'ctagsargs': 'default'
" \ }

" Diary creation {{{1

function! OpenJournal()
  let filename = strftime('%Y-%m-%d') . '.org'
  let filepath = g:orgmode_journal_path . filename
  execute 'edit ' . filepath
  let pruebareng1=getline(1)
  " echo pruebareng1
  let pruebareng2=getline(3)
  " echo pruebareng2
  if pruebareng1=~ '* ' . strftime('%Y-%m-%d')
    execute 'normal, G'
    $put = '** ' . strftime('%H:%M') . '                 :org-journal:'
    execute 'm $'
  else
    execute 'normal, gg'
    0put = '* ' . strftime('%Y-%m-%d') . '               :org-journal:'
    $put = '** ' . strftime('%H:%M') . '                 :org-journal:'
  endif  
endfunction

command! -nargs=0 Openjournal call OpenJournal()
