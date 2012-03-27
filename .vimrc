
    "###
    "###  TODO: read http://learnvimscriptthehardway.stevelosh.com/
    "###


set nocompatible encoding=utf8 nobackup                         " sane defaults
set ignorecase hlsearch incsearch nowrapscan                    " search settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent   " tab and indent settings
set backspace=indent,eol,start
set ruler                                                       " display row/col
command! W w                                                    " accomodate stuck-shift keys
command! Q q
set clipboard=unnamed                                           " default to the * clipboard when yanking/pasting
set textwidth=100
set guioptions-=T                                               " remove toolbar
set noerrorbells visualbell t_vb=                               " quiet!!!
let mapleader = ","

filetype plugin on                                              " http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
set wildmenu wildmode=list:longest,full                         " http://paperlined.org/apps/vim/wildmenu.html


let $STDIN_OWNERS_HOME = ($STDIN_OWNERS_HOME != "") ? $STDIN_OWNERS_HOME : $HOME
silent! call pathogen#infect($STDIN_OWNERS_HOME . "/.vim/bundle")

if $LOGNAME != "root"       " modeline can compromise security
    set modeline
endif


" the colors from diff-highlights really clash with the colors from syntax-hilights, so turn the latter off
set t_Co=256
if &diff
    syntax off
    colorscheme evening
else
    syntax on
    if v:version >= 700
        let g:solarized_termcolors=256
        syntax enable
        set background=light
        colorscheme solarized
    else
        "colorscheme desert
        colorscheme pablo
    endif
endif



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


" ========================= http://vimbits.com/ ===================
" ========================= vvvvvvvvvvvvvvvvvvv ===================

" Located in another file, but you REALLY MUST swap the capslock and escape keys, it saves SOOO much time.
"       http://vim.wikia.com/wiki/Map_caps_lock_to_escape_in_XWindows
"       http://vim.wikia.com/wiki/Map_caps_lock_to_escape_in_Windows

" swap the : and ; keys
" This helps TWO ways: 1) no more held-down shift key problems (eg. :Q), and 2) you use the command-line WAYYYY more
"           http://vim.wikia.com/wiki/Map_semicolon_to_colon
nnoremap ; :| nnoremap : ;
vnoremap ; :| vnoremap : ;

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" use + and - to increment/decrement
nnoremap + <C-a>| nnoremap - <C-x>

" scroll the viewpoint faster
nnoremap <C-e> 5<C-e> 
nnoremap <C-y> 5<C-y>

" keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

" make F1 act as escape so you don't have to worry about it
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" take the line under the cursor, and run it as a vim command
nnoremap <leader>S ^vg_y:execute @@<CR>

" ========================= ^^^^^^^^^^^^^^^^^^^ ===================
" ========================= http://vimbits.com/ ===================



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




" make Ctrl-Up and Ctrl-Down modify the font size    (unfortunately, ctrl-plus and ctrl-minus can't be bound)
if has("gui_gtk2")
    " The syntax for &guiformat is totally different between GTK+2 and non-GTK,
    " and the below is designed only for GTK+2.

    " if we don't set an initial guifont, the below code won't work
    set guifont=Liberation\ Mono\ 10

    let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
    let s:minfontsize = 6
    let s:maxfontsize = 24
    function! AdjustFontSize(amount)
      if has("gui_gtk2") && has("gui_running")
        let fontname = substitute(&guifont, s:pattern, '\1', '')
        let cursize = substitute(&guifont, s:pattern, '\2', '')
        let newsize = cursize + a:amount
        if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
          let newfont = fontname . newsize
          let &guifont = newfont
        endif
      else
        echoerr "You need to run the GTK2 version of Vim to use this function."
      endif
    endfunction

    nnoremap <C-MouseDown> :silent! call AdjustFontSize(1)<CR>
    nnoremap <C-MouseUp> :silent! call AdjustFontSize(-1)<CR>
endif



" ======================== persistence ======================

" http://vim.wikia.com/wiki/Make_views_automatic
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview


" http://vimbits.com/bits/242
" Only available in Vim 7.3+
if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif
