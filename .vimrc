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
autocmd BufEnter *.creole set textwidth=0


" Take care of forgetting to use sudo with :w!!
cmap w!! w !sudo tee % > /dev/null


"   :CC     do a syntax-check on the current Perl program
"   :PP     run the current Perl program
command! PP        !PATH=.:$PATH %
command! PPL       !PATH=.:$PATH % | less
command! CC        !perl -c % 2>&1 | head -20


noremap ;; ;| map ; :|                                         " swap the : and ; keys



" Originally from http://www.noah.org/engineering/dotfiles/.vimrc
" License unclear.
"
" Automatically load templates for new files. Silent if the template for the
" extension does not exist. Virtually all template plugins I have seen for Vim
" are too complicated. This just loads what extension matches in
" $VIMHOME/templates/. For example the contents of html.tmpl would be loaded
" for new html documents.
augroup BufNewFileFromTemplate
au!
autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tmpl
autocmd BufNewFile * normal! G"_dd1G
autocmd BufNewFile * silent! match Todo /TODO/
augroup BufNewFileFromTemplate


autocmd BufWrite *.pl silent !chmod a+x %



" NOTE: if you want to start pathogen from an override ~/.vimrc file, then call infect like this:
"
"       call pathogen#infect(expand('<sfile>:p:h') . "/.vim/bundle")
