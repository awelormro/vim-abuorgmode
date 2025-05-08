# -*- coding: utf-8 -*-

import os
import subprocess
import tempfile

import vim

from orgmode._vim import ORGMODE, echoe, echom
from orgmode.menu import Submenu, ActionEntry, add_cmd_mapping_menu
from orgmode.keybinding import Keybinding, Plug, Command
from orgmode import settings


from orgmode.py3compat.encode_compatibility import *
from orgmode.py3compat.unicode_compatibility import *
from orgmode.py3compat.py_py3_string import *
from orgmode.py3compat.py_py3_string import *


pandoc_export_backends = {
    u'beamer': u'beamer',
    u'tex' : u'latex',
    u'html' : u'html'
}

class PandocExport(object):
    u"""
    The need to add some features, such as a 
    more complex exportation commands using tools like 
    pandoc to not directly depend on orgmode
    """
    def __init__(self):
        u""" Initialize plugin """
        object.__init__(self)
        # menu entries this plugin should create
        self.menu = ORGMODE.orgmenu + Submenu(u'PandocExport')

        # key bindings for this plugin
        # key bindings are also registered through the menu so only additional
        # bindings should be put in this variable
        self.keybindings = []

        # commands for this plugin
        self.commands = []

        
    @classmethod
    def _get_init_script(cls):
        init_script = settings.get(u'org_pandoc_export_init_script', u'')
        if init_script:
            init_script = os.path.expandvars(os.path.expanduser(init_script))
            if os.path.exists(init_script):
                return init_script
            else:
                echoe(u'Unable to find init script %s' % init_script)

    @classmethod
    def _export(cls, format_):
        """Export current file to format.

        Args:
            format_: pdf or html

        Returns:
            return code
        """
        pandocbin = os.path.expandvars(os.path.expanduser(
            settings.get(u'org_export_pandoc', u'/usr/bin/pandoc')))
        if not os.path.exists(pandocbin):
            echoe(u'Unable to find pandoc binary %s' % pandocbin)

        # build the export command
        # pandocbin = u'pandoc'
        expanded_path = vim.eval('expand("%")')
        partial_name=expanded_path[:-3]
        if pandoc_export_backends[format_]=='beamer':
            partial_name=partial_name + 'pdf'
        cmd = [
                pandocbin, 
                u'-s',
                u'--parse_raw',
                u'-f', 
                u'org+smart', 
                expanded_path,
                u'-t', 
                pandoc_export_backends[format_], 
                u'-o', 
                partial_name
                ]
        print(cmd)
        # with open(expanded_path,'r',encoding='utf-8') as f:
        #     contenido=f.read()
        # export
        # com=''
        # for string in cmd:
        #     com+=string + ' '
        # print(com)
        # commandout='system("' + com + '")'
        # vim.eval(commandout) 
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
        p.wait()
        output, error = p.communicate()
        
        # print(output.decode())
        return p.returncode
        # if p.returncode != 0 or settings.get(u'org_export_verbose') == 1:
        #     echom('\n'.join(map(lambda x: x.decode(), p.communicate())))
        #     # echom('\n'.join(map(lambda x: x.encode(encoding='utf8'), p.communicate())))
        # return p.returncode

    @classmethod
    def tobeamer(cls):
        u"""Export the current buffer as beamer pdf using emacs orgmode."""
        ret = cls._export(u'beamer')
        if ret != 0:
            echoe(u'PDF export failed.')
        else:
            echom(u'Export successful: %s.%s' % (vim.eval(u'expand("%:r")'), 'pdf'))

    def register(self):
        u"""Registration and keybindings."""

        # path to emacs executable
        settings.set(u'org_export_pandoc', u'/usr/bin/pandoc')
        # verbose output for export
        settings.set(u'org_export_verbose', 0)
        # allow the user to define an initialization script
        settings.set(u'org_export_init_script', u'')

        # to Beamer PDF
        add_cmd_mapping_menu(
            self,
            name=u'OrgPandocExportToBeamerPDF',
            function=u':%s ORGMODE.plugins[u"PandocExport"].tobeamer()<CR>' % VIM_PY_CALL,
            key_mapping=u'<localleader>peb',
            menu_desrc=u'To Beamer PDF (via Pandoc)'
        )
