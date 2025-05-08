
if !exists('main_syntax')
  let main_syntax = 'org'
endif

if has('folding')
  let s:foldmethod = &l:foldmethod
  let s:foldtext = &l:foldtext
endif
let s:iskeyword = &l:iskeyword

runtime! syntax/html.vim
unlet! b:current_syntax

if !exists('g:org_fenced_languages')
  let g:org_fenced_languages = []
endif
let s:done_include = {}
 for s:type in map(copy(g:org_fenced_languages),'matchstr(v:val,"[^=]*$")')
  if has_key(s:done_include, matchstr(s:type,'[^.]*'))
    continue
  endif
  if s:type =~ '\.'
    let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
  endif
  syn case match
  exe 'syn include @orgHighlight_'.tr(s:type,'.','_').' syntax/'.matchstr(s:type,'[^.]*').'.vim'
  unlet! b:current_syntax
  let s:done_include[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:done_include

syn spell toplevel
if exists('s:foldmethod') && s:foldmethod !=# &l:foldmethod
  let &l:foldmethod = s:foldmethod
  unlet s:foldmethod
endif
if exists('s:foldtext') && s:foldtext !=# &l:foldtext
  let &l:foldtext = s:foldtext
  unlet s:foldtext
endif
if s:iskeyword !=# &l:iskeyword
  let &l:iskeyword = s:iskeyword
endif
unlet s:iskeyword

if !exists('g:org_minlines')
  let g:org_minlines = 50
endif
execute 'syn sync minlines=' . g:org_minlines
syn sync linebreaks=1
syn case ignore

syn match orgValid '[<>]\c[a-z/$!]\@!' transparent contains=NONE
syn match orgValid '&\%(#\=\w*;\)\@!' transparent contains=NONE

syn match orgLineStart "^[<@]\@!" nextgroup=@orgBlock,htmlSpecialChar

syn cluster orgBlock contains=orgH1,orgH2,orgH3,orgH4,orgH5,orgH6,orgBlockquote,orgListMarker,orgOrderedListMarker,orgCodeBlock,orgRule
syn cluster orgInline contains=orgLineBreak,orgLinkText,orgItalic,orgBold,orgCode,orgEscape,@htmlTop,orgError,orgValid

syn match orgH1 "^.\+\n=\+$" contained contains=@orgInline,orgHeadingRule,orgAutomaticLink
syn match orgH2 "^.\+\n-\+$" contained contains=@orgInline,orgHeadingRule,orgAutomaticLink

syn match orgHeadingRule "^[-]\+$" contained

syn region orgH1 matchgroup=orgH1Delimiter start=" \{,3}\* \s"      end="\* *\s*$" keepend oneline contains=@orgInline,orgAutomaticLink contained
syn region orgH2 matchgroup=orgH2Delimiter start=" \{,3}\*\* \s"     end="\* *\s*$" keepend oneline contains=@orgInline,orgAutomaticLink contained
syn region orgH3 matchgroup=orgH3Delimiter start=" \{,3}\*\*\* \s"    end="\* *\s*$" keepend oneline contains=@orgInline,orgAutomaticLink contained
syn region orgH4 matchgroup=orgH4Delimiter start=" \{,3}\*\*\*\* \s"   end="\* *\s*$" keepend oneline contains=@orgInline,orgAutomaticLink contained
syn region orgH5 matchgroup=orgH5Delimiter start=" \{,3}\*\*\*\*\* \s"  end="\* *\s*$" keepend oneline contains=@orgInline,orgAutomaticLink contained
syn region orgH6 matchgroup=orgH6Delimiter start=" \{,3}\*\*\*\*\*\* \s" end="\* *\s*$" keepend oneline contains=@orgInline,orgAutomaticLink contained

syn match orgBlockquote ">\%(\s\|$\)" contained nextgroup=@orgBlock

syn region orgCodeBlock start="^\n\( \{4,}\|\t\)" end="^\ze \{,3}\S.*$" keepend

" TODO: real nesting
syn match orgListMarker "\%(\t\| \{0,4\}\)[-*+]\%(\s\+\S\)\@=" contained
syn match orgOrderedListMarker "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@=" contained

syn match orgRule "\* *\* *\*[ *]*$" contained
syn match orgRule "- *- *-[ -]*$" contained

syn match orgLineBreak " \{2,\}$"

syn region orgIdDeclaration matchgroup=orgLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=orgUrl skipwhite
syn match orgUrl "\S\+" nextgroup=orgUrlTitle skipwhite contained
syn region orgUrl matchgroup=orgUrlDelimiter start="<" end=">" oneline keepend nextgroup=orgUrlTitle skipwhite contained
syn region orgUrlTitle matchgroup=orgUrlTitleDelimiter start=+"+ end=+"+ keepend contained
syn region orgUrlTitle matchgroup=orgUrlTitleDelimiter start=+'+ end=+'+ keepend contained
syn region orgUrlTitle matchgroup=orgUrlTitleDelimiter start=+(+ end=+)+ keepend contained

syn region orgLinkText matchgroup=orgLinkTextDelimiter start="!\=\[\%(\_[^][]*\%(\[\_[^][]*\]\_[^][]*\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=orgLink,orgId skipwhite contains=@orgInline,orgLineStart
syn region orgLink matchgroup=orgLinkDelimiter start="(" end=")" contains=orgUrl keepend contained
syn region orgId matchgroup=orgIdDelimiter start="\[" end="\]" keepend contained
syn region orgAutomaticLink matchgroup=orgUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline

let s:concealends = ''
if has('conceal') && get(g:, 'org_syntax_conceal', 1) == 1
  let s:concealends = ' concealends'
endif
exe 'syn region orgItalic matchgroup=orgItalicDelimiter start="\*\S\@=" end="\S\@<=\*\|^$" skip="\\\*" contains=orgLineStart,@Spell' . s:concealends
exe 'syn region orgItalic matchgroup=orgItalicDelimiter start="\w\@<!_\S\@=" end="\S\@<=_\w\@!\|^$" skip="\\_" contains=orgLineStart,@Spell' . s:concealends
exe 'syn region orgBold matchgroup=orgBoldDelimiter start="*\*\*\S\@=" end="\S\@<=\*\*\|^$" skip="\\\*" contains=orgLineStart,orgItalic,@Spell' . s:concealends
exe 'syn region orgBold matchgroup=orgBoldDelimiter start="\w\@<!__\S\@=" end="\S\@<=__\w\@!\|^$" skip="\\_" contains=orgLineStart,orgItalic,@Spell' . s:concealends
exe 'syn region orgBoldItalic matchgroup=orgBoldItalicDelimiter start="\*\*\*\S\@=" end="\S\@<=\*\*\*\|^$" skip="\\\*" contains=orgLineStart,@Spell' . s:concealends
exe 'syn region orgBoldItalic matchgroup=orgBoldItalicDelimiter start="\w\@<!___\S\@=" end="\S\@<=___\w\@!\|^$" skip="\\_" contains=orgLineStart,@Spell' . s:concealends
exe 'syn region orgStrike matchgroup=orgStrikeDelimiter start="\~\~\S\@=" end="\S\@<=\~\~\|^$" contains=orgLineStart,@Spell' . s:concealends

syn region orgCode matchgroup=orgCodeDelimiter start="=" end="=" keepend contains=orgLineStart
syn region orgCode matchgroup=orgCodeDelimiter start="`` \=" end=" \=``" keepend contains=orgLineStart
syn region orgCodeBlock matchgroup=orgCodeDelimiter start="^\s*\z(`\{3,\}\).*$" end="^\s*\z1\ze\s*$" keepend
syn region orgCodeBlock matchgroup=orgCodeDelimiter start="^\s*\z(\~\{3,\}\).*$" end="^\s*\z1\ze\s*$" keepend

syn match orgFootnote "\[^[^\]]\+\]"
syn match orgFootnoteDefinition "^\[^[^\]]\+\]:"

let s:done_include = {}
for s:type in g:org_fenced_languages
  if has_key(s:done_include, matchstr(s:type,'[^.]*'))
    continue
  endif
  exe 'syn region orgHighlight_'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=orgCodeDelimiter start="^\s*\z(`\{3,\}\)\s*\%({.\{-}\.\)\='.matchstr(s:type,'[^=]*').'}\=\S\@!.*$" end="^\s*\z1\ze\s*$" keepend contains=@orgHighlight_'.tr(matchstr(s:type,'[^=]*$'),'.','_') . s:concealends
  exe 'syn region orgHighlight_'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=orgCodeDelimiter start="^\s*\z(\~\{3,\}\)\s*\%({.\{-}\.\)\='.matchstr(s:type,'[^=]*').'}\=\S\@!.*$" end="^\s*\z1\ze\s*$" keepend contains=@orgHighlight_'.tr(matchstr(s:type,'[^=]*$'),'.','_') . s:concealends
  let s:done_include[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:done_include

if get(b:, 'org_yaml_head', get(g:, 'org_yaml_head', main_syntax ==# 'org'))
  syn include @orgYamlTop syntax/yaml.vim
  unlet! b:current_syntax
  syn region orgYamlHead start="\%^---$" end="^\%(---\|\.\.\.\)\s*$" keepend contains=@orgYamlTop,@Spell
endif

syn match orgEscape "\\[][\\`*_{}()<>#+.!-]"
syn match orgError "\w\@<=_\w\@="

hi def link orgH1                    htmlH1
hi def link orgH2                    htmlH2
hi def link orgH3                    htmlH3
hi def link orgH4                    htmlH4
hi def link orgH5                    htmlH5
hi def link orgH6                    htmlH6
hi def link orgHeadingRule           orgRule
hi def link orgH1Delimiter           orgHeadingDelimiter
hi def link orgH2Delimiter           orgHeadingDelimiter
hi def link orgH3Delimiter           orgHeadingDelimiter
hi def link orgH4Delimiter           orgHeadingDelimiter
hi def link orgH5Delimiter           orgHeadingDelimiter
hi def link orgH6Delimiter           orgHeadingDelimiter
hi def link orgHeadingDelimiter      Delimiter
hi def link orgOrderedListMarker     orgListMarker
hi def link orgListMarker            htmlTagName
hi def link orgBlockquote            Comment
hi def link orgRule                  PreProc

hi def link orgFootnote              Typedef
hi def link orgFootnoteDefinition    Typedef

hi def link orgLinkText              htmlLink
hi def link orgIdDeclaration         Typedef
hi def link orgId                    Type
hi def link orgAutomaticLink         orgUrl
hi def link orgUrl                   Float
hi def link orgUrlTitle              String
hi def link orgIdDelimiter           orgLinkDelimiter
hi def link orgUrlDelimiter          htmlTag
hi def link orgUrlTitleDelimiter     Delimiter

hi def link orgItalic                htmlItalic
hi def link orgItalicDelimiter       orgItalic
hi def link orgBold                  htmlBold
hi def link orgBoldDelimiter         orgBold
hi def link orgBoldItalic            htmlBoldItalic
hi def link orgBoldItalicDelimiter   orgBoldItalic
hi def link orgStrike                htmlStrike
hi def link orgStrikeDelimiter       orgStrike
hi def link orgCodeDelimiter         Delimiter

hi def link orgEscape                Special
hi def link orgError                 Error

let b:current_syntax = "org"
if main_syntax ==# 'org'
  unlet main_syntax
endif

" vim:set sw=2:
