set nocompatible encoding=utf8 nobackup                         " sane defaults
set ignorecase hlsearch incsearch                               " search settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent   " tab and indent settings
set backspace=indent,eol,start
set ruler                                                       " display row/col
command W w                                                     " accomodate stuck-shift keys
command Q q
set clipboard=unnamed                                           " default to the * clipboard when yanking/pasting
set textwidth=100
set guioptions-=T                                               " remove toolbar
set noerrorbells visualbell t_vb=                               " quiet!!!

filetype plugin on                                              " http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
set wildmenu wildmode=list:longest,full                         " http://paperlined.org/apps/vim/wildmenu.html



syntax on
if &diff | syntax off | endif                                   " syntax hilighting is too hard to see during diffs...  just show the diff colors



" don't wrap lines in HTML files
autocmd BufEnter *.html set textwidth=0


" Take care of forgetting to use sudo with :w!!
cmap w!! w !sudo tee % > /dev/null


"   :CC     do a syntax-check on the current Perl program
"   :PP     run the current Perl program
command! PP        !PATH=.:$PATH %
command! PPL       !PATH=.:$PATH % | less
command! CC        !perl -c % 2>&1 | head -20


noremap ;; ;| map ; :|                                         " swap the : and ; keys

