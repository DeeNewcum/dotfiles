    " Use ,S here to have a rough simulation of folds:
    "       /^"\s*==.*



    "###
    "###  TODO: read http://learnvimscriptthehardway.stevelosh.com/
    "###
    
    "###  for tips on making sure your centralized .vimrc works across many different versions of
    "###  Vim -- old and new -- see:
    "###        http://blog.sanctum.geek.nz/gracefully-degrading-vimrc/



        " VVV  TODO: Consider getting folds to work on these sorts of headers:
        "      https://vim.fandom.com/wiki/Syntax_folding_of_Vim_scripts

"======== basic settings ========

set nocompatible encoding=utf8 nobackup                         " sane defaults
set ignorecase hlsearch incsearch nowrapscan                    " search settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent   " tab and indent settings
set wrap linebreak                                              " enable line wrap, and don't wrap in the middle of a word
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


"======== diffs and syntax coloring ========

" the colors from diff-highlights really clash with the colors from syntax-hilights, so turn the latter off
set t_Co=256
if &diff

    "==== diff-only settings ====
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

    " several settings that make it MUCH easier to keep track of things while
    " using a horizontal split within vimdiff       (accomplished by pressing Ctrl-W J)
    set cursorline      " hilight the current line
    set scrollbind      " both windows scroll together
    if exists('+cursorbind')
        set cursorbind      " both cursors move together
    endif

    " OH GOD, hack hack. This causes every press on the up or down arrows to
    " switch back and forth between the windows once, which updates the cursor
    " position on the other window.
    " See here for more -- https://stackoverflow.com/questions/5227964/
    nnoremap j j:let curwin=winnr()<CR>:keepjumps windo redraw<CR>:execute curwin . "wincmd w"<CR>
    nnoremap k k:let curwin=winnr()<CR>:keepjumps windo redraw<CR>:execute curwin . "wincmd w"<CR>
else
    syntax enable
    if &t_Co == 256 || has('gui_running')
        let g:solarized_termcolors=&t_Co    " terminfo knows how many colors are available
        set background=light
        if !has("win32")                    " if we're running on Windows, then we're missing most files, only the .vimrc has been copied over
            silent! colorscheme solarized
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
    "match ErrorMsg /\( \|^\)\@<!   \+/

    " hilight where the "textwidth" setting lies
    if exists('+colorcolumn')
        set colorcolumn=+1        " highlight column after 'textwidth'
            " NOTE: colorcolumn has a negative side-effect:  when you copy-n-paste things
            "       using the terminal-emulator's functionality (instead of Vim's internal features)
            "       a bunch of extraneous spaces get appended to each line.
            "       TODO: research ways to avoid this side-effect
            "             or, failing that, use a different method to hilight the 'textwidth'
            "             point:    http://vim.wikia.com/wiki/Highlight_long_lines
    else
        match ErrorMsg "\%>79v.\+"      " before Vim 7.3, we have to do something different
    endif
endif

                " This gets run whenever the colorscheme changes.
function! Dee_colorscheme_overrides()
    " =========================================================================
    " vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    " =========================================================================

    " I use visual mode whenever I yank something, so people looking over my
    " shoulder can see what I yank. Make that yank more prominent and even
    " easier to see.
    hi Visual   term=standout ctermfg=15 ctermbg=4 guifg=White guibg=Red

    " needed for visual consistency with PlainText_Toggle()
    if &t_Co == 256 || has('gui_running')
        hi! NonText ctermbg=242 guibg=DarkGrey
    else
        hi! NonText ctermbg=7 ctermfg=0 guibg=DarkGrey
    endif

    if has("spell")             " spell-check settings
        set spelllang=en_us
        hi clear SpellBad
        hi link SPellBad ErrorMsg
    endif

    " The color of "black space" at the bottom of a file, and the line-wrap indicator.
    if ! &diff && (&t_Co == 256 || has('gui_running'))
        hi NonText ctermbg=242 guibg=DarkGrey
    endif

    " =========================================================================
    " ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    " =========================================================================
endfunction

" Tweaks to the syntax, that should OVERRIDE any new colorscheme or filetype settings.
autocmd ColorScheme * call Dee_colorscheme_overrides()

" If the colorscheme never changes, we still want to apply these changes once.
call Dee_colorscheme_overrides()



"======== (unorganized) ========

" ,t = toggle between plain-(t)ext mode and programming mode
nnoremap <leader>t :call PlainText_Toggle()<cr>


" toggle between plain-(t)ext mode and programming mode
function PlainText_Toggle()
    if &textwidth==0 && &wrap==1
        call PlainText_Disable()
        echom "programming mode enabled"
    else
        call PlainText_Enable()
        echom "plain-text mode enabled"
    endif
endfunction


function PlainText_Enable()
    set textwidth=0
    call clearmatches()     " I use matches on Vims that are too old to support tw
    silent!   set colorcolumn=
    set nolist
    set wrap
    set linebreak               " indicate lines that are wrapped
    let &showbreak = '  '       " indicate lines that are wrapped
    set expandtab

    call PlainText_Both()
endfunction


" also known as "enable programming mode"
function PlainText_Disable()
    set textwidth=100
    if exists('+colorcolumn')
        set colorcolumn=+1        " highlight column after 'textwidth'
    else
        match ErrorMsg "\%>79v.\+"      " before Vim 7.3, we have to do something different
    endif
    set list listchars=tab:##
    set nowrap

    call PlainText_Both()
endfunction


" TODO: Does this have to exist?
function PlainText_Both()
    " indicate lines that are wrapped
    if &t_Co == 256 || has('gui_running')
        hi! NonText ctermbg=242 guibg=DarkGrey
    else
        hi! NonText ctermbg=7 ctermfg=0 guibg=DarkGrey
    endif
endfunction


" Prevent saving if the filename has a semicolon in it.
"       (the semicolon/colon swap above causes me to often save files named ";w" and such)
autocmd BufWriteCmd *;* call NoSemicolon()
function! NoSemicolon()
  echohl WarningMsg | echo "The filename can't contain a semicolon." | echohl None
endfunction


" https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif


" Use whole "words" when opening URLs.
" This avoids cutting off parameters (after '?') and anchors (after '#'). 
" See http://vi.stackexchange.com/q/2801/1631
let g:netrw_gx="<cWORD>"


" Features that don't work well over a slow terminal.  TODO: have a way to disable them when needed.
"           http://vimdoc.sourceforge.net/htmldoc/term.html#slow-fast-terminal
"           https://www.reddit.com/r/vim/comments/4hz0u2/sensible_horizontal_scrolling_howto_make_vim/#d2tqjg5
" if not is_slow()              <-- pseudocode, TODO: replace me with a user setting like :slow
    set sidescroll=1 nowrap sidescrolloff=10    " scroll sideways like every other normal editor
" endif

" we don't enable spell-checking here...  rather, it gets enabled on a per-filetype basis
" in the ~/.vim/ftplugin/ files   (see :help ftplugin-overrule)
function! Enable_Spell_Check()
    if has("spell") && !&diff
        set spell                                                   " enable spell-checking
    endif
endfunction


set notitle     " don't change the xterm title -- the one set by ~/.bashrc is the one I prefer

" take care of forgetting to use sudo with :w
cmap w!! w !sudo tee % > /dev/null


" :Q    forcibly quit everything, and don't worry about saving changes
command! Q         qa!
cmap     wQ        w \| qa!


" Show the hierarchy of the synstack() -- the hierarchy of syntax IDs -- and the highlight groups
" associated with them. This is useful for debugging highlighting and syntaxes.
" 
" Originally from https://github.com/dylnmc/synstack.vim/blob/master/autoload/synstack.vim
function! ShowSynStack()
    let first = 1
    unsilent echon "\r"
    for id in reverse(synstack(line('.'), col('.')))
        if first
            let first = 0
        else
            unsilent echon ' <- '
        endif
        let syn = synIDattr(id, 'name')
        let transId = synIDtrans(id)
        execute 'echohl ' syn
        unsilent echon syn
        if id !=# transId
            unsilent echon ' [' synIDattr(transId, 'name') ']'
        endif
        echohl NONE
    endfor
    echohl NONE
    if first
        unsilent echon 'No syntax groups under cursor'
    endif
endfunction


" Originally from http://www.noah.org/engineering/dotfiles/.vimrc
" License unclear.
"
" Automatically load templates for new files. Silent if the template for the
" extension does not exist. Virtually all template plugins I have seen for Vim
" are too complicated. This just loads what extension matches in
" $VIMHOME/templates/. For example the contents of html.tmpl would be loaded
" for new html documents.
function _BufNewFileFromTemplate()
    " BUG -- For some reason, when ~/.vim/templates/md.tmpl is read in, the :read command stops at
    "        the line that starts with a hash.
    silent! 0read $HOME/.vim/templates/%:e.tmpl
    normal! G"_dd1G
    match Todo /TODO/
endfunction




"======== http://vimbits.com/ ========
" vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

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

" ,s = toggle spell-check
nnoremap <leader>s :setl spell!<CR>|

" ,S = take the line under the cursor, and run it as a vim command
nnoremap <leader>S ^vg_y:@"<CR>     " Default to using the entire line.
vnoremap <leader>S y:@"<CR>         " It also works if you use visual/select mode to highlight specific text first.

" ,l  = lock in the current-search pattern
" ,L  = clear all locked-in search patterns
nnoremap <leader>l :call matchadd('Visual', @/)<cr>
nnoremap <leader>L :call clearmatches()<cr>

nnoremap <leader>z :call ShowSynStack()<cr>





"======== GUI (both in Windows and Linux) ========

if has("win32")
    source $VIMRUNTIME/mswin.vim

    " I really dislike that mswin.vim overwrites Ctrl-F, which I use often, and not for
    " searching-within-a-file.
    "       https://github.com/vim/vim/issues/1457
    unmap <C-F>
endif


" make Ctrl-Up and Ctrl-Down modify the font size    (unfortunately, ctrl-plus and ctrl-minus can't be bound)
if has("gui_running")
    " The syntax for &guiformat is totally different between GTK+2 and non-GTK,
    " and the below is designed only for GTK+2.

    " if we don't set an initial guifont, the below code won't work
    set guifont=Liberation\ Mono\ 10

    " from https://vim.fandom.com/wiki/Change_font_size_quickly
    function! AdjustFontSize(amount)
        if !has("gui_running")
            return
        endif

        let l:min_font_size = 5
        let l:max_font_size = 23

        let l:font_info = GetFontInfo()
        if l:font_info.name == '' || l:font_info.size == ''
            return
        endif

        let l:font_name = l:font_info.name
        let l:font_size = l:font_info.size

        " Decrease font size.
        if a:amount == '-'
            let l:font_size = l:font_size - 1

        " Increase font size.
        elseif a:amount == '+'
            let l:font_size = l:font_size + 1

        " Use a specific font size.
        elseif str2nr(a:amount)
            let l:font_size = str2nr(a:amount)
        endif

        " Clamp font size.
        let l:font_size = max([l:min_font_size, min([l:max_font_size, l:font_size])])

        if matchstr(&guifont, ':') == '' " Linux guifont style.
            " \v           Very magical.
            " (\d+$)       Capture group:       Match [0-9] one-or-more times, at the end of the string.
            let l:font_size_pattern = '\v(\d+$)'
        else " Windows and macOS guifont style.
            " \v           Very magical.
            " (:h)@<=      Positive lookbehind: Match ':h'.
            " (\d+)        Capture group:       Match [0-9] one-or-more times.
            let l:font_size_pattern = '\v(:h)@<=(\d+)'
        endif

        " Update vim font size.
        let &guifont = substitute(&guifont, l:font_size_pattern, l:font_size, '')
    endfunction

    function! GetFontInfo()
        " Windows and macOS &guifont: Hack NF:h11:cANSI
        "                             3270Medium_NF:h10:W500:cANSI:qDRAFT
        " Linux &guifont: Hack Nerd Font Mono Regular 10

        if matchstr(&guifont, ':') == '' " Linux guifont style.
            " \v           Very magical.
            " (^.{-1,})    Capture group:       Anchored at the start of the string, match any character one-or-more times non-greedy.
            " ( \d+$)@=    Positive lookahead:  Match ' ' followed by [0-9] one-or-more times, at the end of the string.
            let l:font_name_pattern = '\v(^.{-1,})( \d+$)@='

            " \v           Very magical.
            " (\d+$)       Capture group:       Match [0-9] one-or-more times, at the end of the string.
            let l:font_size_pattern = '\v(\d+$)'
        else " Windows and macOS guifont style.
            " \v           Very magical.
            " (^.{-1,})    Capture group:       Anchored at the start of the string, match any character one-or-more times non-greedy.
            " (:)@=        Positive lookahead:  Match ':'.
            let l:font_name_pattern = '\v(^.{-1,})(:)@='

            " \v           Very magical.
            " (:h)@<=      Positive lookbehind: Match ':h'.
            " (\d+)        Capture group:       Match [0-9] one-or-more times.
            let l:font_size_pattern = '\v(:h)@<=(\d+)'
        endif

        let l:font_name = matchstr(&guifont, l:font_name_pattern)
        let l:font_size = matchstr(&guifont, l:font_size_pattern)

        return { 'name' : l:font_name, 'size' : l:font_size }
    endfunction

    " Bind Control + Mouse-wheel to zoom text.
    " NOTE: This event only works in Linux and macOS. SEE: :h scroll-mouse-wheel
    map <silent> <C-ScrollWheelDown> :call AdjustFontSize('-')<CR>
    map <silent> <C-ScrollWheelUp> :call AdjustFontSize('+')<CR>

    " Decrease font size.
    nnoremap <silent> <F11> :call AdjustFontSize('-')<CR>
    inoremap <silent> <F11> <Esc>:call AdjustFontSize('-')<CR>
    vnoremap <silent> <F11> <Esc>:call AdjustFontSize('-')<CR>
    cnoremap <silent> <F11> <Esc>:call AdjustFontSize('-')<CR>
    onoremap <silent> <F11> <Esc>:call AdjustFontSize('-')<CR>

    " Increase font size.
    nnoremap <silent> <F12> :call AdjustFontSize('+')<CR>
    inoremap <silent> <F12> <Esc>:call AdjustFontSize('+')<CR>
    vnoremap <silent> <F12> <Esc>:call AdjustFontSize('+')<CR>
    cnoremap <silent> <F12> <Esc>:call AdjustFontSize('+')<CR>
    onoremap <silent> <F12> <Esc>:call AdjustFontSize('+')<CR>
endif


if has("win32") && has("gui_running")
    set guifont=Lucida_Console:h11:cANSI:qDRAFT
endif


"======== persistence ========

" If we're doing a diff, we DON'T want any fancy colors or settings.
" We want the colors to be EXACTLY as specified in the 'if &diff' section above.
if ! &diff
    " http://vim.wikia.com/wiki/Make_views_automatic
    autocmd BufWinLeave ?* mkview
    autocmd BufWinEnter ?* silent loadview
else
    " see for more -- https://stackoverflow.com/questions/3878692/how-to-create-an-alias-for-a-command-in-vim
    fun! SetupCommandAlias(from, to)
        exec 'cnoreabbrev <expr> '.a:from
              \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
              \ .'? ("'.a:to.'") : ("'.a:from.'"))'
    endfun

    " remap :q to :qall, to allow the user to quit BOTH windows at once, within vimdiff
    call SetupCommandAlias("q", "qall")

    " allow the user to toggle back and forth between ignoring whitespace and not
    function! IwhiteToggle()
        if &diffopt =~ 'iwhite'
            set diffopt-=iwhite
        else
            set diffopt+=iwhite
            set diffexpr=""
        endif
    endfunction
    nnoremap <leader>w :call IwhiteToggle()<CR>
endif


            " TODO: Is this functionality duplicated with the above section labelled ==== persistence ==== ?
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


"======== filetype-specific tweaks ========

augroup BufNewFileFromTemplate
    autocmd!
    autocmd BufNewFile * :call _BufNewFileFromTemplate()
augroup END


" don't wrap lines in HTML files
autocmd   BufEnter   *.html,*.md   call PlainText_Enable()


autocmd   BufWrite   *.pl,*.py   silent !chmod a+x %


"   :CC     do a syntax-check on the current Perl program
"   :PP     run the current Perl program
command! PP        !PATH=.:$PATH %
command! PPL       !PATH=.:$PATH % | less
command! CC        !perl -c % 2>&1 | head -20
    " TODO: use  "python -m py_compile %"   for Python scripts
    "       and  "ruby -c %"   for Ruby scripts
    "       or just use this?   https://github.com/tomtom/checksyntax_vim






"======== (unorganized) ========

" ...



