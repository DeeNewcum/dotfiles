##  easily edit & reload aliases
alias rl='. ~/.bash_aliases'
alias ea='${EDITOR:-vi} ~/.bash_aliases; rl'

## combinations of less/grep/find/xargs
function lgrep()  { grep -Zls  "$@" | xargs -0 less    -p "$1"; }
function lgrepi() { grep -Zlsi "$@" | xargs -0 less -i -p "$1"; }
function xgrep() { xargs -i grep "$@" /dev/null {} ; }   

function largefiles() { find ${1:-~} -type f -print0 | xargs -0 ls -l | sort -n -k 5 | tail -100 | perl -ple 's/^(?:\S+\s+){4}//; s/$ENV{HOME}/~/'; }
function largedirs() { du -k ${1:-~} | sort -n | tail -100; }
function largeindividualdirs() { du -Sk ${1:-~} | sort -n | tail -1000; }

function vimwhich()  { vim  `which $1`; }
function lesswhich() { less `which $1`; }

