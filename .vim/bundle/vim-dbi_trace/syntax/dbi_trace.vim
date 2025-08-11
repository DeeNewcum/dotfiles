" Vim syntax file                                                                                                                                      
" Language:      syntax file for Perl DBI's trace logs
" Maintainer:    dee.newcum@gmail.com
" License:       Vim License (see :help license)                                                                                                       

" Quit when a syntax file was already loaded.
if exists('b:current_syntax') |   finish |   endif

setlocal foldmethod=syntax

" make fold=syntax work
syn region Query start=/\v^    -\> prepare for DBD::/ end=/\v^    \<- finish/ fold contains=ALL

syn match bindValue          "\vbind :\S+ \<\=\= \zs'[^']*"
syn match query              "\v\cdbd_st_prepare'd sql \S+$"        nextgroup=queryReadOnly, queryReadWrite
" syn cluster query2      contains=querySelect,queryUpdate,queryDelete,queryInsert
syn match queryReadOnly      "\v^\s*select>.*"
syn match queryReadWrite     "\v^\s*(update|insert|delete)>.*"
syn match errorString        "\v<err(str)?\='\zs[^']+"

syn match CmdConnect         "\v-\> \zsconnect>"
syn match CmdFetchrow        "\v<fetch[\^a-z_]*"
syn match CmdExecute         "\v-\> \zsexecute"
syn match CmdPrepare         "\v-\> \zsprepare>"

hi def link bindValue        WarningMsg
hi def link queryReadOnly    DiffAdd
hi def link queryReadWrite   DiffDelete
hi def link errorString      Type

hi def link CmdConnect       Conceal
hi def link CmdFetchrow      Conceal
hi def link CmdExecute       Conceal
hi def link CmdPrepare       Conceal

let b:current_syntax = 'dbi_trace'
