##  easily edit & reload aliases
alias rl='. ~/.bash_aliases'
alias ea='${EDITOR:-vi} ~/.bash_aliases; rl'


# Bash equivalents to tcsh built-ins
function where { type -pa "$@" | perl -nle 'print unless $seen{$_}++'; }
alias rehash='hash -r'



function xargs_newline() { perl -e 'my@a=map{chomp;$_}<STDIN>;system@ARGV,splice(@a,0,200)while(@a)' "$@"; }
if [ "`uname`" != "SunOS" ]; then
    ## combinations of less/grep/find/xargs
    function lgrep()  { grep -Zls  "$@" | xargs -0 less    -p "$1"; }
    function lgrepi() { grep -Zlsi "$@" | xargs -0 less -i -p "$1"; }
    function xgrep() { xargs -i grep "$@" /dev/null {} ; }              # Solaris version only, needed for its underpowered find/xargs/grep arguments

    function largefiles() { find ${1:-~} -type f -print0 | xargs -0 ls -l | sort -n -k 5 | tail -100 | perl -ple 's/^(?:\S+\s+){4}//; s/$ENV{HOME}/~/'; }
    function largedirs() { du -k ${1:-~} | sort -n | tail -100; }
    function largeindividualdirs() { du -Sk ${1:-~} | sort -n | tail -1000; }
else
    # Try to make the fundamental Solaris tools a wee bit easier to use
    function find- { find2perl "$@" -print | perl; }

    ## combinations of less/grep/find/xargs
    function lgrep()  { grep -ls  "$@" | xargs_newline less    -p "$1"; }
    function lgrepi() { grep -lsi "$@" | xargs_newline less -i -p "$1"; }
    function xgrep()  { xargs_newline grep "$@" /dev/null; }              # Solaris version only, needed for its underpowered find/xargs/grep arguments
    function xlgrep() { xargs_newline grep -l "$@" /dev/null | xargs less; }        # Solaris version only, needed for its underpowered find/xargs/grep arguments

    function largefiles() { /bin/find ${1:-$PWD}  ! -local -prune -o -type f -print | xargs_newline /bin/ls -l | filesize_sort | tail -100; }
    function largedirs() { /usr/bin/du -k ${1:-$PWD} | sort -n; }
    function largedirs_onelevel() { /bin/ls -1 | perl -nle 'print qq[$ENV{PWD}/$_] if -d' | xargs_newline du -sk | sort -n | perl -ple 's/^(\d+?)\d\d\d\s/\1mb\t/'; }
    function large_txtfiles() { /bin/find $PWD ! -local -prune -o -type f -print | perl -nle 'print if -T' | xargs_newline /bin/ls -l | filesize_sort | tail -100; }
fi

function vimwhich()  { vim  $(type -P $1); }
function lesswhich() { less $(type -P $1); }


# gnome-open, kde-open, etc
function go() { xdg-open "$@"; }
function goscp() { perl -MFile::Temp -le 'chdir(File::Temp::tempdir()); system "scp", $ARGV[0], "."; system "xdg-open *"' "$@"; }


# Do ANSI-coloring of text, based on arbitrary regexps.
# see documentation:  https://github.com/DeeNewcum/individual_scripts/blob/master/hil.md
function hil { perl -0777pe'BEGIN{$p=join"|",map{"($_)"}grep{++$i%2}@ARGV;@c=grep{$j++%2}@ARGV;@ARGV=()}s/$p/for($i=0;$i<@c&&!defined$-[$i+1];$i++){}"\e[$c[$i]m$+\e[0m"/gome' "$@"; }



alias gitk_everything='gitk --all $( git rev-list --all --walk-reflogs ) &'


if [ "$(type -P apt-get)" ];  then
    alias upup='sudo apt-get update; sudo apt-get upgrade'
fi




alias google='w3m google.com'


