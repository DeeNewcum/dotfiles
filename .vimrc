
    "###
    "###  TODO: read http://learnvimscriptthehardway.stevelosh.com/
    "###
    
    "###  for tips on making sure your centralized .vimrc works across many different versions of
    "###  Vim -- old and new -- see:
    "###        http://blog.sanctum.geek.nz/gracefully-degrading-vimrc/


set nocompatible encoding=utf8 nobackup                         " sane defaults
set ignorecase hlsearch incsearch nowrapscan                    " search settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent   " tab and indent settings
set backspace=indent,eol,start
set ruler                                                       " display row/col
set hidden                                                      " make it possible to use buffers
command! W w                                                    " accomodate stuck-shift keys
command! Q q
set clipboard=unnamed                                           " default to the * clipboard when yanking/pasting
set textwidth=100
set noerrorbells visualbell t_vb=                               " quiet!!!
set lazyredraw                                                  " don't redraw while in macros
let mapleader = ","

filetype plugin on                                              " http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
set wildmenu wildmode=list:longest,full                         " http://paperlined.org/apps/vim/wildmenu.html

set guioptions-=T                                               " remove toolbar
set guioptions+=b                                               " add horizontal scrollbar


let $STDIN_OWNERS_HOME = ($STDIN_OWNERS_HOME != "") ? $STDIN_OWNERS_HOME : $HOME
silent! call pathogen#infect($STDIN_OWNERS_HOME . "/.vim/bundle")

if $LOGNAME != "root"       " modeline can compromise security
    set modeline
endif

" the colors from diff-highlights really clash with the colors from syntax-hilights, so turn the latter off
"set t_Co=256
if &diff
    syntax off
    colorscheme evening
    " This event list is almost certainly overkill.  Things that are known to be definitely needed:
    "       SessionLoadPost         -- needed for           set list listchars=eol:$                mkview
    autocmd BufNewFile,FileReadPost,BufRead,FilterReadPost,StdinReadPost,BufNew,BufCreate,BufEnter,BufWinEnter,VimEnter,SessionLoadPost * call Diff_ClearSettings()
    function! Diff_ClearSettings()
        setlocal nospell
        setlocal nolist
        silent! setlocal colorcolumn=
    endfunction
else
    syntax enable
    if &t_Co == 256 || has('gui_running')
        let g:solarized_termcolors=&t_Co    " terminfo knows how many colors are available
        set background=light
        if !has("win32")                    " if we're running on Windows, then we're missing most files, only the .vimrc has been copied over
            colorscheme solarized
        endif
    else
            " Solarized looks ugly in 16 colors, so fallback to something else
            " Also, Solarized doesn't work in 88 colors  (urxvt)
        "colorscheme pablo
            " pablo doesn't include a ctermbg, which mucks things up in some terminals
        colorscheme desert
            " Putty's colors make things hard to read, *particularly* dark blue
        highlight normal ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
        if match($TERM, "rxvt-unicode")!=-1
            silent !echo -ne "\033]12;white\007"
            autocmd VimLeave * silent !echo -ne "\033]12;black\007"
        endif
    endif

    if !has("win32")            " This REALLY should be done without a has(), but I'm short on time right now.
        " make tabs visible
        set list listchars=tab:› 
    endif

    " hilight tabs that are used for alignment -- we only want to use them for indenting
    "match ErrorMsg /\(	\|^\)\@<!	\+/

    if exists("&colorcolumn")
        set colorcolumn=+1        " highlight column after 'textwidth'
            " NOTE: colorcolumn has a negative side-effect:  when you copy-n-paste things
            "       using the terminal-emulator's functionality (instead of Vim's internal features)
            "       a bunch of extraneous spaces get appended to each line.
            "       TODO: research ways to avoid this side-effect
            "             or, failing that, use a different method to hilight the 'textwidth'
            "             point:    http://vim.wikia.com/wiki/Highlight_long_lines
    endif
endif

if has("spell")             " spell-check settings
    set spelllang=en_us
    hi clear SpellBad
    hi link SPellBad ErrorMsg
endif

" Features that don't work well over a slow terminal.  TODO: have a way to disable them when needed.
"           http://vimdoc.sourceforge.net/htmldoc/term.html#slow-fast-terminal
"           https://www.reddit.com/r/vim/comments/4hz0u2/sensible_horizontal_scrolling_howto_make_vim/#d2tqjg5
" if not is_slow()              <-- pseudocode, TODO: replace me with a user setting like :slow
    set sidescroll=1 nowrap sidescrolloff=10    " scroll sideways like every other normal editor
" endif

nnoremap <leader>s :setl spell!<CR>|            " toggle spell-check
nnoremap <leader>w :setl wrap!<CR>|             " toggle line-wrap
nnoremap <leader>x :exec getreg('*')<CR>        " take what's in the buffer, and execute it as VimScript

" we don't enable spell-checking here...  rather, it gets enabled on a per-filetype basis
" in the ~/.vim/ftplugin/ files   (see :help ftplugin-overrule)
function! Enable_Spell_Check()
    if has("spell") && !&diff
        set spell                                                   " enable spell-checking
    endif
endfunction


set notitle     " don't change the xterm title -- the one set by ~/.bashrc is the one I prefer



" don't wrap lines in HTML files
autocmd BufEnter *.html set textwidth=0
autocmd BufEnter *.md set textwidth=0
autocmd BufEnter *.creole set textwidth=0


" take care of forgetting to use sudo with :w
cmap w!! w !sudo tee % > /dev/null


"   :CC     do a syntax-check on the current Perl program
"   :PP     run the current Perl program
command! PP        !PATH=.:$PATH %
command! PPL       !PATH=.:$PATH % | less
command! CC        !perl -c % 2>&1 | head -20
    " TODO: use  "python -m py_compile %"   for Python scripts
    "       and  "ruby -c %"   for Ruby scripts
    "       or just use this?   https://github.com/tomtom/checksyntax_vim

" :Q    forcibly quit everything, and don't worry about saving changes
command! Q         qa!
cmap     wQ        w \| qa!

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

" make F1 act as escape so you don't have to worry about it
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" take the line under the cursor, and run it as a vim command
nnoremap <leader>S ^vg_y:execute @@<CR>

" <leader>l  = lock in the current-search pattern
" <leader>L  = clear all locked-in search patterns
nnoremap <leader>l :call matchadd('Visual', @/)<cr>
nnoremap <leader>L :call clearmatches()<cr>

" ========================= ^^^^^^^^^^^^^^^^^^^ ===================
" ========================= http://vimbits.com/ ===================



" Use 'smart tabs'  -- tabs for indenting, spaces for aligning


" toggle between spaces and tabs  (to do a manual form of "smart tabs")
nnoremap <C-t> :set et!<cr>
vnoremap <C-t> :set et!<cr>


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
autocmd BufWrite *.py silent !chmod a+x %




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


" If we're doing a diff, we DON'T want any fancy colors or settings.
" We want the colors to be EXACTLY as specified in the 'if &diff' section above.
if ! &diff
    " http://vim.wikia.com/wiki/Make_views_automatic
    autocmd BufWinLeave ?* mkview
    autocmd BufWinEnter ?* silent loadview
endif


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




" Prevent saving if the filename has a semicolon in it.
"       (the semicolon/colon swap above causes me to often save files named ";w" and such)
autocmd BufWriteCmd *;* call NoSemicolon()
function! NoSemicolon()
  echohl WarningMsg | echo "The filename can't contain a semicolon." | echohl None
endfunction


if has("win32")
    source $VIMRUNTIME/mswin.vim
endif


" https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif
