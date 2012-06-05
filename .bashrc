# .bashrc is for interactive non-login shells, .bash_profile is for login shells
[ -z "$PS1" ] && return


# $PATH
[ -d ~/bin/ ]      && export PATH=$HOME/bin:$PATH
[ -d ~/apps/bin/ ] && export PATH=~/apps/bin/:$PATH     # custom-compiled apps that override the system ones


# prompt
XTERM_TITLE='\[\033]0;\h\007\]'
PS1=$XTERM_TITLE'\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # Note: As suggested by:
    #           http://tldp.org/HOWTO/Bash-Prompt-HOWTO/xterm-title-bar-manipulations.html
    #       we should only update the Xterm title when we're SURE that the end-user's terminal
    #       supports this feature.  Currently, all of mine do, and also my $TERM is an unreliable
    #       way to check if the end-user's terminal does.  So, for now, I'm always sending this.


# vi mode
set -o vi
bind -m vi-insert \\C-l:clear-screen        # make Ctrl-L work the same as it does in emacs mode


# $EDITOR and $PAGER
if type -P vim > /dev/null; then
    export EDITOR=vim
    #export PAGER=vimpager
#else
#    type -P less >/dev/null && export PAGER='less -i'
fi
type -P less >/dev/null && export PAGER='less -i'


# history
HISTCONTROL=ignoreboth      # don't put duplicate lines or lines starting with space in the history.
shopt -s histappend         # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&:ls:clear"


# find the most capable termcap entry
for term in    gnome-256color  xterm-256color  xterm  vt100
do
    if tput -T$term colors >/dev/null 2>/dev/null; then 
        export TERM=$term
        break
    fi
done
# TODO: some terminals respond to     echo -e '\005'
#           see ENQ/answerback at  http://paperlined.org/apps/terminals/queries.html


###################################################
#################  COLOR  #########################
###################################################
# enable color for as many things as possible

export GREP_OPTIONS='--color=auto' 

alias ls='ls --color=auto -F'

# man pages
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;34m'         # begin blinking
export LESS_TERMCAP_md=$'\E[01;34m'         # begin bold
export LESS_TERMCAP_me=$'\E[0m'             # end mode
export LESS_TERMCAP_so=$'\E[01;44;33m'      # begin standout (hilighted) mode
export LESS_TERMCAP_se=$'\E[0m'             # end standout mode
export LESS_TERMCAP_us=$'\E[01;32m'         # begin underline
export LESS_TERMCAP_ue=$'\E[0m'             # end underline
###################################################


if [ $USER = "root" ]; then
    # take care when overwriting things, if root
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
fi


# make X apps work properly when changing to root, without having to use sux/sudox
[ -z "$XAUTHORITY" -a -n "$DISPLAY" -a -e "$HOME/.Xauthority" ] && export XAUTHORITY="$HOME/.Xauthority"
    # Note: For this to work, you also have to add the following to /etc/sudoers:
    #           Defaults env_keep += "DISPLAY XAUTHORIZATION XAUTHORITY"


# make less be able to open up tar files and gzip files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


[ -f ~/.bash_aliases ] && source ~/.bash_aliases


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
