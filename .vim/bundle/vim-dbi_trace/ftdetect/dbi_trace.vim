function! DetectDBITrace()
    " Detect file type based on the contents.
    if getline(1) =~ '\vDBI::db\=\S+ trace level set to'
        setfiletype dbi_trace
    endif
endfunction

augroup filetypedetect
    au BufRead,BufNewFile * call DetectDBITrace()
augroup END
