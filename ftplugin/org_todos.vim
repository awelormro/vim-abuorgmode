vim9script
def OrgTodoShifter()
  # What I want to make:
  # - Select 
  # Get the current line
  var cur_line = getline('.')
  var line_number = line('.')
  if cur_line =~ '^\*'
    # Split the line using spaces
    var splitted_line = split(copy(cur_line), ' ')
    # if splitted_line[1] in g:org_todo_keywords
      var i = 0
      while i < len(g:org_todo_keywords)
        if splitted_line[1] == g:org_todo_keywords[i]
          # use deletebu
          # deletebufline()
          echo 'Done'
        endif
        i += 1
      endwhile
    # endif
  endif
enddef
