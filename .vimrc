set incsearch hlsearch
set enc=utf-8               " default encoding


" Take care of forgetting to use sudo with :w!!
cmap w!! w !sudo tee % > /dev/null


"   :CC     do a syntax-check on the current Perl program
"   :PP     run the current Perl program
command! PP        !PATH=.:$PATH %
command! CC        !perl -c % 2>&1 | head -20
