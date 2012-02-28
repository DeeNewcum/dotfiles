# .bashrc is for interactive non-login shells, .bash_profile is for login shells

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Make less be able to open up tar files and gzip files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f ~/.bash_aliases ] && source ~/.bash_aliases

[ -d ~/bin/ ] && export PATH=$PATH:$HOME/bin

# avoid having to use sux/sudox when changing to root    (this line cooperates with /etc/sudoers env_keep)
[ -n "$DISPLAY" -a -e "$HOME/.Xauthority" ] && export XAUTHORITY="$HOME/.Xauthority"


PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


set -o vi
if [ "`which vim`" ];  then export EDITOR=vim;      fi
if [ "`which less`" ]; then export PAGER='less -i'; fi



if [ "`tput -Tgnome-256color colors 2>/dev/null`" = "256" ]; then 
    TERM=gnome-256color 
elif [ "`tput -Txterm-256color colors 2>/dev/null`" = "256" ]; then 
    TERM=xterm-256color 
elif tput -Tgnome colors 2>/dev/null; then 
    TERM=gnome 
fi 


# load PerlBrew settings, if available
[ -f ~/perl5/perlbrew/etc/bashrc ] && source ~/perl5/perlbrew/etc/bashrc
