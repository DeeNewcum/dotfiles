" Vim syntax file                                                                                                                                      
" Language:      syntax file for Perl DBI's trace logs
" Maintainer:    dee.newcum@gmail.com
" License:       Vim License (see :help license)                                                                                                       

" Quit when a syntax file was already loaded.
if exists('b:current_syntax') |   finish |   endif

syn match bindValue         "\vbind :\S+ \<\=\= \zs'[^']*"
syn match fetchRow          "\v<fetch[\^a-z_]*"
syn match query             "\v\cdbd_st_prepare'd sql \S+$"        nextgroup=queryReadOnly, queryReadWrite
" syn cluster query2      contains=querySelect,queryUpdate,queryDelete,queryInsert
syn match queryReadOnly     "\v^\s*select>.*"
syn match queryReadWrite    "\v^\s*(update|insert|delete)>.*"
syn match errorString       "\v<err(str)?\='\zs[^']+"

hi def link bindValue        String
hi def link fetchRow         Define
hi def link queryReadOnly    DiffAdd
hi def link queryReadWrite   DiffDelete
hi def link errorString      HelpNote

let b:current_syntax = 'dbi_trace'
