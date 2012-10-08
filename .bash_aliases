##  easily edit & reload aliases
alias rl='. ~/.bash_aliases'
alias ea='${EDITOR:-vi} ~/.bash_aliases; rl'


# Bash equivalents to tcsh built-ins
function where { type -pa "$@" | perl -nle 'print unless $seen{$_}++'; }
alias rehash='hash -r'



function xargs_newline() { perl -e 'my@a=map{chomp;$_}<STDIN>;system@ARGV,splice(@a,0,200)while(@a)' "$@"; }
if [ "`uname`" != "SunOS" ]; then
    # lgrep = grep, and display the results in less   (where you use :n and :p to view all results)
    # xgrep = pipe a list of filenames in, and it greps only those files
    function lgrep()  { grep -Zls  "$@" | xargs -0 less    -p "$1"; }
    function lgrepi() { grep -Zlsi "$@" | xargs -0 less -i -p "$1"; }

    ## identify excessively large files
    function largefiles() { find ${1:-~} -type f -print0 | xargs -0 ls -l | sort -n -k 5 | tail -100 | perl -ple 's/^(?:\S+\s+){4}//; s/$ENV{HOME}/~/; $_=reverse;s/(\d\d\d)(?=\d)(?!\d*\.)(?=[\d,]*$)/$1,/g;$_=reverse'; }
    function largedirs() { du -k ${1:-~} | sort -n | tail -100; }
    function largeindividualdirs() { du -Sk ${1:-~} | sort -n | tail -1000; }
else
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
function xgrep()   { xargs_newline -i grep "$@" /dev/null {} ; }
function xlgrep()  { xargs_newline grep -l "$@" /dev/null    | xargs less    -p "$1"; }
function xlgrepi() { xargs_newline grep -l -i "$@" /dev/null | xargs less -i -p "$1"; }


# just like 'cd', except that it can also accept filenames, in which case it will CD to the directory *containing* that file
function cdd { if [ -f "$1" ]; then cd $(dirname "$1"); else cd "$1"; fi; }


    # fully dereference and canonicalize a file...  should work on anything:  stuff in $PATH, symlinks, whatever
#function abs() { readlink -e $(which "$1"); }
function abs() { perl -MCwd=abs_path -e 'print abs_path(shift), "\n"' "$( [ -e "$1" ] && echo "$1" || which "$1" )"; }

# combinations of 'which' with other programs
function vimw()      { vim  $(which "$1"); }
function lessw()     { less $(which "$1"); }
function cdw()       { cdd $(abs $(which "$1" )); }      # more like "cduaw", but whatever

# combinations of 'rurl' with other programs
function vimu()      { vim   $(rurl "$1"); }
function lessu()     { less  $(rurl "$1"); }
function cdu()       { cdd   $(rurl "$1"); }
function touchu()    { touch $(rurl "$1"); }


# gnome-open, kde-open, etc
function go() { xdg-open "$@"; }
#function goscp() { perl -MFile::Temp -le 'chdir(File::Temp::tempdir()); system "scp", $ARGV[0], "."; system "xdg-open *"' "$@"; }


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


####[ screen + tmux ]####
# reattach to the screen named 'main'   (or create it if it doesn't exist)
alias   srm='screen -U -dr main || screen -U -S main'
# reattach to the screen named 'main'   (or create it if it doesn't exist)
alias   tmx='tmux attach -t main || tmux new -s main'




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
alias lasttmp='ls -1td /var/tmp/* | perl -nle "print if -f && -O" | head | perl -nle "print if -T" | xargs less'
                        # once in less, use '[' and ']' (or :n and :p) to quickly scan the files


# Do an mboxgrep search, and display the results in mutt.
# Arguments are EXACTLY the same as mboxgrep's arguments.
function mmboxgrep() { local tmp=$(mktemp); mboxgrep "$@" > $tmp; mutt -f $tmp; rm -f $tmp; }


alias gitk_everything='gitk --all $( git rev-list --all --walk-reflogs ) &'


if [ "$(type -p apt-get)" ];  then
    alias upup='sudo apt-get update; sudo apt-get upgrade'
fi




alias google='w3m google.com'


if [ -z "$(type _feh 2>/dev/null)" ]; then
    function _feh { feh --recursive --full-screen --auto-zoom --draw-filename ${1:-.} 2>/dev/null & }
fi


function unball { cd /var/tmp; eval $(command unball "$@"); }
