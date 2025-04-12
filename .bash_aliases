##  easily edit & reload aliases
alias rl='. ~/.bash_aliases'
alias ea='${EDITOR:-vi} ~/.bash_aliases; rl'


# Bash equivalents to tcsh built-ins
function where { type -pa "$@" | perl -nle 'print unless $seen{$_}++'; }
alias rehash='hash -r'

# A quick way to update my dotfiles from Github.
#function updot {
#    DOTFILES_DIR=$( dirname $( readlink ~/.lesskey ) )
#    (
#        cd $DOTFILES_DIR;
#        [ -d .git/ ] && git pull origin;
#        echo;
#        ./deedot
#    )
#}



# Perl replacement for 'uniq'; unlike the system version, this doesn't require the input to be sorted
#       note: RAM usage is O(n)    (probably;  Perl's hash algorithm may be complex)
puniq() { perl -nle 'print unless $SEEN{$_}++' "$@"; }

function xargs_newline() { perl -e 'my@a=map{chomp;$_}<STDIN>;system@ARGV,splice(@a,0,200)while(@a)' "$@"; }
if [ "`uname`" != "SunOS" ]; then
    ######## not SunOS ########
    
    # lgrep = grep, and display the results in less   (where you use :n and :p to view all results)
    # xgrep = pipe a list of filenames in, and it greps only those files
    function lgrep()  { grep -Zls  "$@" | xargs -0 less    -p "$1"; }
    function lgrepi() { grep -Zlsi "$@" | xargs -0 less -i -p "$1"; }

    # vimgrep = grep, and edit all the files that match the pattern
    function vimgrep() { vim $( grep -l "$@" * ) -c "call cursor(1,1)" -c "/${@: -1}"; }

    ## identify excessively large files
    function largefiles() { find ${1:-~} -type f -print0 | xargs -0 ls -l | sort -n -k 5 | tail -100 | perl -ple 's/^(?:\S+\s+){4}//; s/$ENV{HOME}/~/; $_=reverse;s/(\d\d\d)(?=\d)(?!\d*\.)(?=[\d,]*$)/$1,/g;$_=reverse'; }
    function largedirs() { du -k ${1:-~} | sort -n | tail -100 | _du_human; }
    function largeindividualdirs() { du -Sk ${1:-~} | sort -n | tail -1000 | _du_human; }

    ## The above functions don't work very well when you run them on the root-dir, because 
    ## they navigate down /proc/ and others. The below functions fix this.
    function largeindividualdirs_rootdir { find / -maxdepth 1 -path /dev -o -path /proc -o -path /sys -prune -o -not -path / -print0 | du --files0-from=- -Sk | sort -n | tail -50 | _du_human; }
        ## TODO vvvvv doesn't seem to work at all on our webserver
    function largedirs_rootdir { find / -maxdepth 1 -path /dev -o -path /proc -o -path /sys -prune -o -not -path / -print0 | xargs -0 du -k | sort -n | tail -50 | _du_human; }

    ### TODO: try to get the below working. It should be more reliable than the above.
    ### 
    ### find / -type d -fstype 'sysfs' -o -fstype 'proc' -o -fstype 'devtmpfs' -o -fstype 'tmpfs' -prune -o -print0 | du --files0-from=- -Sk | sort -n | tail -50 | _du_human
else
    ######## SunOS ########

    # Try to make the fundamental Solaris tools a wee bit easier to use
    function find- { find2perl "$@" -print | perl; }

    # lgrep = grep, and display the results in less   (where you use :n and :p to view all results)
    # xgrep = pipe a list of filenames in, and it greps only those files
    function lgrep()  { grep -ls  "$@" | xargs_newline less    -p "$1"; }
    function lgrepi() { grep -lsi "$@" | xargs_newline less -i -p "$1"; }

    ## identify excessively large files
    function largefiles() { /bin/find ${1:-$PWD}  ! -local -prune -o -type f -print | xargs_newline /bin/ls -l | filesize_sort | tail -100; }
    function largedirs() { /usr/bin/du -k ${1:-$PWD} | sort -n; }
    function largedirs_onelevel() { /bin/ls -1 | perl -nle 'print qq[$ENV{PWD}/$_] if -d' | xargs_newline du -sk | sort -n | perl -ple 's/^(\d+?)\d\d\d\s/\1mb\t/'; }
    function large_txtfiles() { /bin/find $PWD ! -local -prune -o -type f -print | perl -nle 'print if -T' | xargs_newline /bin/ls -l | filesize_sort | tail -100; }
fi
function xgrep()   { xargs_newline -i grep "$@" /dev/null ; }
function xlgrep()  { xargs_newline grep -l "$@" /dev/null    | xargs less    -p "$1"; }
function xlgrepi() { xargs_newline grep -l -i "$@" /dev/null | xargs less -i -p "$1"; }


################################################################################
##
## For aliases and scripts whose name starts with "0", that means it processes
## a list of null-separated records, along the lines of `find -print0` or
## `xargs -0`. TYPICALLY these will be a list of filenames, but it could
## potentially be a list of other things.
##

# Call just like `find`, though it has a few defaults that I prefer.
function 0find()    { find $PWD "$@" -print0; }

# This doesn't search the contents of the files, rather it searches through the
# *names* of the files.
function 0grep {
    if [ $# -eq 0 ]; then
        echo "A regex must be specified." >&2 
    else
        perl -0 -nle 'BEGIN {$re = qr/$ARGV[0]/o; shift} print if $_ =~ $re' "$@";
    fi
}

# Call just like `xargs -0 grep`, with all arguments passed through to grep.
# Set it to the lowest scheduling priority to avoid impacting resources on
# important servers.
#function 0xgrep()   { nice -n 19 xargs -0 grep "$@"; }
# Actually, use 'tcpgrep' (Tom Christiansen's rewrite of grep) instead of the
# system grep, since that automatically greps inside .gz files and such.
function 0xgrep()   { nice -n 19 xargs -0 tcgrep -H "$@"; }
function sudo_0xgrep()   { sudo -- nice -n 19 xargs -0 "$(which tcgrep)" "$@"; }
function sudoE_0xgrep()   { sudo -E -- nice -n 19 xargs -0 "$(which tcgrep)" "$@"; }
    # ^^^ to be clear, these take null-separated records on INPUT, but if 
    #     the '-l' flag is used, the output is newline-separated

function sudo_0excerpt() { sudo "$(which 0excerpt)" "$@"; }
function sudoE_0excerpt() { sudo -E "$(which 0excerpt)" "$@"; }

# Just for convenience, change the null-record-separator to a newline, to make
# it easier for the user to read the list. Hopefully this gets used for
# diagnostic purposes only, and not as a way to use non-null versions of xargs
# et al.
alias 0print='perl -0 -l012 -p -e "$|++; 1"'


# List which files have been modified most recently.
function 0recentfiles {
    perl -0e 'print join chr(0), splice @{[  sort {-M $b <=> -M $a} map {chomp; $_} <>  ]}, -40' \
        | xargs -0 ls --color -UlrdF 2>/dev/null
}

# The opposite of what '0print' does -- changes newlines back to nulls.
# See also:  the Perl script '0read'
alias 0unprint='tr "\n" "\000"'


# Show line-count and byte-count.
alias 0wc='xargs --no-run-if-empty -0 -- wc -l -c'


# Opens the list of files sent to STDIN, using Vim. All arguments are passed directly to Vim.
function 0vim {
    # The /dev/tty thing works around the "vim: input is not from a terminal" error.
    # See https://unix.stackexchange.com/a/44428/52831
    cat - | xargs -0 -- sh -c 'vim "$@" < /dev/tty' vim "$@"
                                                      # ^^^^ These are the arguments passed to '0vim'.
                                 # ^^^^ These are the arguments passed from 'xargs' to 'sh'.
}


# Just like '0vim', but for less.
function 0less {
    cat - | xargs -0 -- sh -c 'less "$@" < /dev/tty' less "$@"
}

################################################################################




## TODO -- This overlaps in functionality with function cd() below. Consider deleting this.
# just like 'cd', except that it can also accept filenames, in which case it will CD to the directory *containing* that file
function cdd { if [ -f "$1" ]; then cd $(dirname "$1"); else cd "$1"; fi; }


    # fully dereference and canonicalize a file...  should work on anything:  stuff in $PATH, symlinks, whatever
#function abs() { readlink -e $(which "$1"); }
function abs() { perl -MCwd=abs_path -e 'print abs_path(shift), "\n"' "$( [ -e "$1" ] && echo "$1" || which "$1" )"; }

# combinations of 'which' with other programs
function vimw()      { vim  $(which "$1"); }
function lessw()     { less $(which "$1"); }
function cdw()       { cdd $(abs $(which "$1" )); }      # more like "cduaw", but whatever
alias vimwhich=vimw
alias lesswhich=lessw
alias cdwhich=cdw

# combinations of 'rurl' with other programs
function vimu()      { vim   $(rurl "$1"); }
function lessu()     { less  $(rurl "$1"); }
function cdu()       { cdd   $(rurl "$1"); }
function touchu()    { touch $(rurl "$1"); }


# gnome-open, kde-open, etc
function go() { xdg-open "$@"; }
#function goscp() { perl -MFile::Temp -le 'chdir(File::Temp::tempdir()); system "scp", $ARGV[0], "."; system "xdg-open *"' "$@"; }

# this is useful for creating files with today's date
alias today='date +%Y%m%d'

alias syslog='tail -fs0 /var/log/syslog'

# launch a tempoary webserver, serving static content from the local directory
function plackup_here() { plackup -MPlack::App::Directory -e 'Plack::App::Directory->new(root => ".");'; }

# List all executable files in a package.  Param#1: package name (apt-get).
# Useful in combination with dmenu.
# Possible future enhancements:
#   - sort by likelihood that the executable is the "main" one for that package, based on:
#           - which ones are in $PATH
#           - which ones have menu entries:
#                   http://standards.freedesktop.org/menu-spec/menu-spec-1.0.html#paths
#   - work for other package managers than apt-get
function execs() { dpkg -L "$1" | perl -nle 'print if -f && -x'; }
if type _comp_dpkg_installed_packages 2>/dev/null >/dev/null; then
    function execs_complete() {
        COMPREPLY=( $( _comp_dpkg_installed_packages "${COMP_WORDS[COMP_CWORD]}" ) )
    }
    complete -F execs_complete execs
fi


# hed / tal -- head/tail that fit your screen's size
#function hed { head -$(perl -MTerm::ReadKey -e 'print((GetTerminalSize)[1] - 2)'); }
#function tal { tail -$(perl -MTerm::ReadKey -e 'print((GetTerminalSize)[1] - 2)'); }
function hed { head -$(stty -F /dev/tty -a | perl -ne 'print $1 - 2 if /rows (\d+)/'); }
function tal { tail -$(stty -F /dev/tty -a | perl -ne 'print $1 - 2 if /rows (\d+)/'); }


# Launch an XWindow-style program from the terminal, while 1) while making sure the program detaches
# fully from the current terminal, and 2) makes sure all stdout and stderr output is hidden.
# 
# For example, if you would normally run:
#           firefox https://www.google.com/search?q=bat+bomb &
# instead run:
#           x  firefox https://www.google.com/search?q=bat+bomb
function x () {
    ( $@ 2>/dev/null 1>/dev/null ) &    2>/dev/null 1>/dev/null 
}


####[ screen + tmux ]####
# reattach to the screen named 'main'   (or create it if it doesn't exist)
alias   sr='screen -U -dr main || screen -U -S main'
alias   srm=sr

# you should configure SecureCRT to send this line when logging in:
#       if [ -n "$(type -t resumescreen_and_exit)" ]; then resumescreen_and_exit; else screen -U -dr main || screen -U -S main; exit; fi
# then you can define your own local alias/function named 'resumescreen_and_exit'

# reattach to the screen named 'main'   (or create it if it doesn't exist)
alias   tmx='tmux new -AD -s main'

# uperl makes it easier to write command-line one-liners that output UTF-8 characters
#        for example,    uperl -le 'print "\x{221e}"'    displays the infinity symbol
alias uperl="perl -Muperl"

# The settings in ~/.lesskey are difficult to override  (particularly -R).  This fixes that.
# This lets you run 'less' with an empty slate, with nothing in the lesskey.
alias less.default='LESSKEY=$HOME/.less.empty less'



# Do ANSI-coloring of text, based on arbitrary regexps.
# see documentation:  https://github.com/DeeNewcum/individual_scripts/blob/master/hil.README.md
function hil { perl -0777pe'BEGIN{$p=join"|",map{"($_)"}grep{++$i%2}@ARGV;@c=grep{$j++%2}@ARGV;@ARGV=()}s/$p/for($i=0;$i<@c&&!defined$-[$i+1];$i++){}"\e[$c[$i]m$+\e[0m"/gome' "$@"; }

# remove ANSI hilighting from text
#           note: this is based on the gem of a document:
#           http://www.vt100.net/emu/dec_ansi_parser
alias ansistrip="perl -000 -pe 's/\e(?:\[\??)?[\x20-\x3f]*[\x40-\x7e]//ig; while (s/[^\x08]\x08//s) {}'"


# I tend to store a LOT of random notes under /var/tmp/, with gibberish filenames...   this lets me quickly scan them, to find
# the one I wanted
#       (they have gibberish filenames on the same theory that GMail doesn't have folders --
#        searching is more important than organizing)
alias lasttmp='ls -1td /var/tmp/* | perl -nle "print if -f && -O" | head -40 | perl -nle "print if -T" | xargs less'
                        # once in less, use '[' and ']' (or :n and :p) to quickly scan the files


# Do an mboxgrep search, and display the results in mutt.
# Arguments are EXACTLY the same as mboxgrep's arguments.
function mmboxgrep() { local tmp=$(mktemp); mboxgrep "$@" > $tmp; mutt -f $tmp; rm -f $tmp; }


alias gitk_everything='gitk --all $( git rev-list --all --walk-reflogs ) &'


if type -p apt-get > /dev/null;  then
    function upup() {
        sudo apt update
        # dist-upgrade is better than upgrade https://itsfoss.com/apt-get-upgrade-vs-dist-upgrade/
        # https://askubuntu.com/questions/194651/why-use-apt-get-upgrade-instead-of-apt-get-dist-upgrade
        sudo apt-get dist-upgrade -y
        [ -f /var/run/reboot-required ] && cat /var/run/reboot-required
    }
fi




alias google='w3m google.com'



##
## There's four commands used for porn-viewing:
##
##             _feh -- View all photos, including subdirectories.  While here, press 0..9 to rate a photo.
##    porn_toprated -- Update the symlinks in ALL .../toprated/ directories.
##      porn_review -- View all semi-toprated photos, in THIS particular .../toprated/ directory.
##             _feh -- Run in a .../toprated/ directory to see all top-rated photos.
##
function _feh {
    FIRST="${1:-.}"
    shift
    feh --recursive --full-screen --auto-zoom --draw-filename \
        --action  ";fehkey 0 %F" \
        --action1 ";fehkey 1 %F" \
        --action2 ";fehkey 2 %F" \
        --action3 ";fehkey 3 %F" \
        --action4 ";fehkey 4 %F" \
        --action5 ";fehkey 5 %F" \
        --action6 ";fehkey 6 %F" \
        --action7 ";fehkey 7 %F" \
        --action8 ";fehkey 8 %F" \
        --action9 ";fehkey 9 %F" \
        "$FIRST" "$@" 2>/dev/null &
    unset FIRST
}
alias thumbnails='(gwenview . &> /dev/null &)'
        # This is related to the porn_toprated program -- view all images that have been reviewed, but haven't crossed the threshold yet.
        # A photo needs at least two reviews before it can be top-rated, but this command lets you view all that are semi-top-rated.
function porn_review {
    if [ -e .review ]; then
        _feh /dev/null --filelist .review
    else
        echo 'You must be in a "toprated" directory'
    fi
}




function unball { cd /var/tmp; eval $(command unball "$@"); }

# do a color-test in Vim
function vim16 { vim "+set t_Co=16   | runtime syntax/colortest.vim"; }
function vim88  { vim "+set t_Co=88  | so $HOME/.vim/VimColorTest.vim"; }
function vim256 { vim "+set t_Co=256 | so $HOME/.vim/VimColorTest.vim"; }


# display the Markdown text from a github project page
function gh-page { perl -0777 -MJSON -ne 'print JSON->new->decode($_)->{body}' params.json \
                        | vim -c 'set syntax=markdown' -; }


# It has been suggested that this fixes some delays with Vim.  Certainly on my main website, I had a
# HUGE number of small files in one of these directories.  I don't know if it's the actual solution
# though.
#               https://github.com/spf13/spf13-vim/issues/349
#               http://unix.stackexchange.com/questions/37076/vim-freezes-for-a-short-time
function cleanVim {
    rm -Rf ~/.vim/view/
    rm -Rf ~/.vim/undo/
    rm -Rf ~/.viminfo
}


# A quick way to recursively fetch a folder
function _wget() { wget -r -nH -np --cut-dirs=$(echo "$1" | perl -ne 'print -3 + ( ()= /\//g )' ) --reject "index.htm*" "$@"; }
                                                                                #  ^^^ goatse operator

alias speaker-test2='echo /usr/share/sounds/alsa/Front_* | xargs -n 1 paplay -v'

alias XMODMAP='xmodmap ~/.Xmodmap'          # workaround since I haven't figured out how to convert xmodmap => XKB      (see comments in ~/.Xmodmap for more)


function tabcheck() {
    echo "Files under the curdir that contain tabs include:"
    find -type f -name .git -prune \
        | perl -nle 'if (readpipe("file --brief $_") =~ /^perl(?! Storable)/i) {system("grep", "-q", "\t", $_) or print}'
}

# Scans all Perl files underneath the current directory, and provides SLOCs and other metrics.
function _countperl() {
    # first make sure Perl::Metrics::Simple has been installed
    perl -MPerl::Metrics::Simple -e0 \
        && find -type f | xargs countperl | less --quit-if-one-screen
}



# allow cd-ing to files
# (what could go wrong?!?)
function cd() {
    if [ $# -eq 0 ]; then
        command cd
    elif [ "$1" = "-" ]; then
        command cd -
    elif [ -d "$1" ]; then
        command cd "$1"
    else
        # quoting inside of $(command substitution) is surprisingly subtle,
        # see -- https://unix.stackexchange.com/a/118438/52831
        command cd "$(dirname -- "$1")"
    fi
}

# Show the whole string of parent processes, starting from the current process, going all the way
# back to init.
function parents() {
    ps -fq "$(pstree -lps $$ | perl -0400 -ple 's/\D+/ /g; s/^\s+|\s+$//g')"
}



########################## Cygwin-specific ##########################
if [ "$(uname -o)" = "Cygwin" ]; then

    # Search for an application directory underneath C:\Program Files\
    # and C:\Program Files (x86)\. The -maxdepth here is important.
    #
    # The arguments are passed directly to 'find', so some example calls:
    #
    #       program_files -iname '*securecrt*'
    #       program_files -ipath '*securecrt*' -type d
    #
    function program_files {
        find '/cygdrive/c/Program Files/' '/cygdrive/c/Program Files (x86)/' \
            -maxdepth 2     \
            "$@" -print0 | xargs -0 -- ls -ldF --color=always

        # Note: Normally -maxdepth should be set to 2, but once in a while
        #       you might want to expand it to 3. This really slows down the
        #       search, however.
    }

    # View *all* the SQL queries that you've written inside SQL Workbench/J
    function sqlworkbench {
         unzip -c \
            $( cygpath -u "$USERPROFILE\\.sqlworkbench\\Default.wksp" ) \
            'WbStatements*.txt' \
            | vim -c 'set syntax=sql' -
    }

fi
########################## Cygwin-specific ##########################


########################## pgrep combinations ##########################
# pgrep + ps -f
# 
# Pass all arguments directly to pgrep, but the output that's displayed is
# like the output of ps -f.
function psgrep() {
    PIDS=$(pgrep -d, "$@")
    if [ -n "$PIDS" ]; then
        ps -fp "$PIDS"
    else
        echo "No processes matched."
    fi
}

# watch + pgrep + ps -f
function watchpsgrep() {
    watch 'ps -fp $(pgrep -d, '"$@"') 2>/dev/null'
}

# pgrep + top
function topgrep() {
    PIDS=$(pgrep -d, "$@")
    if [ -n "$PIDS" ]; then
        top -p "$PIDS"
    else
        echo "No processes matched."
    fi
}

# pgrep -n + pstree
function pstreegrep() {
    PIDS=$(pgrep -n "$@")
    if [ -n "$PIDS" ]; then
        pstree -ap "$PIDS"
    else
        echo "No processes matched."
    fi
}

# watch + pstree + pgrep -n
function watchpstreegrep() {
    watch 'PID=$(pgrep -n '"$@"'); pstree -ap ${PID:-9999999}'
}
########################## pgrep combinations ##########################


# very useful for finding out what the active logfiles are!
alias logfiles='inotifywaitstats /var/log/'


########################## colorizer filters ##########################
# run any command through grc (the generic coloriser)
function @ {
    # is grc available?
    if type -p grc > /dev/null; then
        grc --colour=on "$@" | less -RF 
    else
        "$@" | less -F
    fi
}

alias @psauxf='@ ps -auxf'
alias @lsof='@ lsof'

# filter out all of the non-regular files
function @lsof_regularfiles {
    if type -p grcat > /dev/null; then
        lsof "$@" | lsof_regular_files | grcat conf.lsof | less -RF
    else
        lsof "$@" | lsof_regular_files | less -F
    fi
}

# 'grc' doesn't support 'top', so we'll use 'ps' instead
function @top {
    watch -n 1 -c 'ps aux --sort -%cpu | grcat conf.ps'
}

function @tree {
    tree -C "$@" | less -R
}
########################## colorizer filters ##########################




########################## find files when visiting a new server ##########################
/etc() { find /etc -type f -iname "*$1*"         | xargs -r ls -ld -rt --color=auto -F; }
/var/log() { find /var/log -type f -iname "*$1*" | xargs -r ls -ld -rt --color=auto -F; }
# 'sudo' variants of the above
/etc_() { sudo find /etc -type f -iname "*$1*"         | xargs -r ls -ld -rt --color=auto -F; }
/var/log_() { sudo find /var/log -type f -iname "*$1*" | xargs -r ls -ld -rt --color=auto -F; }
########################## find files when visiting a new server ##########################
