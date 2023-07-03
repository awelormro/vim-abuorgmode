
def indent_orgmode():
    u""" Set the indent value for the current line in the variable
    b:indent_level

    Vim prerequisites:
        :setlocal indentexpr=Method-which-calls-indent_orgmode

    :returns: None
    """
    line = int(vim.eval(u_encode(u'v:lnum')))
    prevline= int(vim.eval(u_encode(u'line(".")')))
    indpline= int(vim.eval(u_encode("indent('.')")))
    print(indpline)
    print(checkbox)
    contprevline=vim.eval(u_encode(u'getline(".")'))
    d = ORGMODE.get_document()
    heading = d.current_heading(line - 1)
    if heading and line != heading.start_vim:
        heading.init_checkboxes()
        checkbox = heading.current_checkbox()
        level = heading.level + 1
        print(checkbox)

        if checkbox:
            if line != checkbox.start_vim:
                # indent body up to the beginning of the checkbox' text
                # if checkbox isn't indented to the proper location, the body
                # won't be indented either
                level = checkbox.level + len(checkbox.type) + 1 + \
                        (4 if checkbox.status else 0)
        if contprevline.strip() == "" or contprevline.isspace():
            level = checkbox.level + len(checkbox.type)  - 5 + \
                    (4 if checkbox.status else 0)
            checkbox = False
        vim.command(u_encode((u'let b:indent_level = %d' % level)))
