# .bashrc is for interactive non-login shells, .bash_profile is for login shells

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Make less be able to open up tar files and gzip files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f ~/.bash_aliases ] && source ~/.bash_aliases

[ -d ~/bin/ ] && export PATH=$HOME/bin:$PATH

# custom-compiled apps that override the system ones
[ -d ~/apps/bin/ ] && export PATH=~/apps/bin/:$PATH


# avoid having to use sux/sudox when changing to root    (this line cooperates with /etc/sudoers env_keep)
[ -z "$XAUTHORITY" -a -n "$DISPLAY" -a -e "$HOME/.Xauthority" ] && export XAUTHORITY="$HOME/.Xauthority"


# Note: As suggested by
#           http://tldp.org/HOWTO/Bash-Prompt-HOWTO/xterm-title-bar-manipulations.html
#       we should only update the Xterm title when we're SURE that the end-user's terminal
#       supports this feature.  Currently, all of mine do, and also my $TERM is an unreliable way to 
#       check if the end-user's terminal does.  So, for now, I'm always sending this.
XTERM_TITLE='\[\033]0;\h\007\]'
PS1=$XTERM_TITLE'\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


set -o vi
bind -m vi-insert "\C-l":clear-screen       # make Ctrl-L work the same as it does in emacs mode
if [ "$(type -P vim)" ];  then
    export EDITOR=vim
    #export PAGER=vimpager
else
    if [ "$(type -P less)" ]; then export PAGER='less -i'; fi
fi
if [ "$(type -P less)" ]; then export PAGER='less -i'; fi



if [ "`tput -Tgnome-256color colors 2>/dev/null`" = "256" ]; then 
    export TERM=gnome-256color 
elif [ "`tput -Txterm-256color colors 2>/dev/null`" = "256" ]; then 
    export TERM=xterm-256color 
elif [ "`tput -Txterm colors 2>/dev/null`" ]; then 
    export TERM=xterm
elif [ "`tput -Tvt100 colors 2>/dev/null`" ]; then 
    export TERM=vt100
fi 



### enable color for as many things as possible ###

export GREP_OPTIONS='--color=auto' 

# man pages
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;34m'         # begin blinking
export LESS_TERMCAP_md=$'\E[01;34m'         # begin bold
export LESS_TERMCAP_me=$'\E[0m'             # end mode
export LESS_TERMCAP_so=$'\E[01;44;33m'      # begin standout (hilighted) mode
export LESS_TERMCAP_se=$'\E[0m'             # end standout mode
export LESS_TERMCAP_us=$'\E[01;32m'         # begin underline
export LESS_TERMCAP_ue=$'\E[0m'             # end underline

alias ls='ls --color=auto -F'


if [ $USER = "root" ]; then
    # take care when overwriting things, if root
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
fi


alias rel2abs='perl -MCwd -e "print Cwd::abs_path shift"'

mkdir -p ~/apps/stow/
mkdir -p ~/apps/build/
[ -d ~/apps/stow ]                 && export STOW_DIR=$(rel2abs $HOME/apps/stow)


# apply PerlBrew and local::lib settings, if available
[ -d ~/perl5 ]                     && export PERL_CPANM_OPT="--local-lib=~/perl5"
[ -d ~/perl5/bin ]                 && export PATH=~/perl5/bin:$PATH
    # apply local::lib bash variables   (using the copy of local::lib that's fatpacked inside cpanm)
[ -f ~/perl5/lib/perl5/local/lib.pm ] && eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
[ -f ~/perl5/perlbrew/etc/bashrc ] && source ~/perl5/perlbrew/etc/bashrc


# you don't want to use local::lib while in PerlBrew
function local_lib_disable {
    unset PERL_LOCAL_LIB_ROOT
    unset PERL_MB_OPT
    unset PERL_MM_OPT
    unset PERL5LIB
}
function local_lib_enable {
    eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
}



# workaround for menu not appearing:
#   https://bugs.launchpad.net/ubuntu/+source/vim/+bug/771810
#   https://bugs.launchpad.net/ubuntu/+source/vim/+bug/776499
function gvim {
    command gvim -f "$@" >/dev/null 2>/dev/null &
    disown
}
