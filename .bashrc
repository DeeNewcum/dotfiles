# .bashrc is for interactive non-login shells, .bash_profile is for login shells

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Make less be able to open up tar files and gzip files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f ~/.bash_aliases ] && source ~/.bash_aliases


