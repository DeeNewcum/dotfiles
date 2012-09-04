# .bashrc is for interactive non-login shells, .bash_profile is for login shells
[ -z "$PS1" ] && return


# $PATH
[ -d ~/bin/ ]      && export PATH=$HOME/bin:$PATH
[ -d ~/apps/bin/ ] && export PATH=~/apps/bin/:$PATH     # custom-compiled apps that override the system ones


# prompt
XTERM_TITLE='\[\033]0;\h\007\]'
[ "$IS_VIRTUAL_CONSOLE" ] && XTERM_TITLE=''         # don't use the Xterm title when at the Linux Virtual Console
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
type -p vim >/dev/null   &&   export EDITOR=vim
type -p less >/dev/null   &&   export PAGER='less -i'
#type -p vimpager >/dev/null   &&   type -p vim >/dev/null   &&   export PAGER=vimpager


# history
HISTCONTROL=ignoredups      # don't put duplicate lines in history
shopt -s histappend         # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="&:ls:clear"


# find the most capable termcap entry
if [ "$TMUX" ]; then
    # per the Tmux manual, when running inside tmux, the terminal *MUST* be set to
    # "screen" or "screen-256color"
    for term in    screen-256color screen
    do
        if tput -T$term colors >/dev/null 2>/dev/null; then 
            export TERM=$term
            break
        fi
    done

else
    for term in    gnome-256color  xterm-256color  xterm  vt100
    do
        if tput -T$term colors >/dev/null 2>/dev/null; then 
            export TERM=$term
            break
        fi
    done
fi
# TODO:
#     - some terminals respond to     echo -e '\005'
#           see ENQ/answerback at  http://paperlined.org/apps/terminals/queries.html
#       try to be a little more intelligent about auto-detecting $TERM
#
#     - possible ways to detect 256 colors:
#       http://www.mudpedia.org/wiki/Xterm_256_colors#Detection


###################################################
#################  COLOR  #########################
###################################################
# enable color for as many things as possible
export GREP_OPTIONS='--color=auto' 

if [ "$(command ls --color 2>&1 >/dev/null)" ]; then
    alias ls='ls -F'
else
    alias ls='ls -F --color=auto'
fi

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
###################################################


###################################################
############  MINIMAL COMPLETION  #################
###################################################
    # Hopefully we have the Bash Completion project installed.
    # But if not, here are a few simplified fallbacks.

    # http://bashcookbook.com/bashinfo/source/bash-4.1/examples/complete/complete-examples
    # http://tldp.org/LDP/abs/html/sample-bashrc.html

shopt -s extglob        # enable extended pattern matching operators

            # returns 0 if the command has a completion rule, 1 if not
function has_complete { complete -p "$1" >/dev/null 2>/dev/null; }

has_complete cd          || complete -o nospace -d cd
has_complete rmdir       || complete -d rmdir
has_complete pushd       || complete -d pushd
has_complete ln          || complete -f ln
has_complete exec        || complete -c nohup exec nice eval trace truss strace sotruss gdb type
has_complete which       || complete -c which
has_complete bg          || complete -A stopped -P '%' bg
has_complete fg          || complete -j -P '%' fg jobs disown
has_complete shopt       || complete -A shopt shopt
has_complete unalias     || complete -a unalias
has_complete unset       || complete -v unset
has_complete su          || complete -u su
has_complete telnet      || complete -A hostname rsh telnet rlogin ftp ping xping host traceroute nslookup
has_complete ssh         || complete -A hostname ssh
has_complete viencrypt   || complete -f -o default -X '!*.+(gpg|GPG)'  viencrypt

has_complete zip         || complete -f -o default -X '*.+(zip|ZIP)'  zip
has_complete unzip       || complete -f -o default -X '!*.+(zip|ZIP)' unzip
has_complete compress    || complete -f -o default -X '*.+(z|Z)'      compress
has_complete uncompress  || complete -f -o default -X '!*.+(z|Z)'     uncompress
has_complete gzip        || complete -f -o default -X '*.+(gz|GZ)'    gzip
has_complete gunzip      || complete -f -o default -X '!*.+(gz|GZ)'   gunzip
has_complete bzip2       || complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
has_complete bunzip2     || complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2


###################################################
###################################################


if [ "$LOGNAME" = "root" ]; then
    # take care when overwriting things, if root
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
fi


# make X apps work properly when changing to root, without having to use sux/sudox
[ -z "$XAUTHORITY" -a -n "$DISPLAY" -a -e "$HOME/.Xauthority" ] && export XAUTHORITY="$HOME/.Xauthority"
    # Note: For this to work, you also have to add the following to /etc/sudoers:
    #           Defaults env_keep += "DISPLAY XAUTHORIZATION XAUTHORITY"


# make ssh-agent work properly when inside tmux
if [[ -z "$TMUX" && ! -z "$SSH_TTY" && ! -z "$SSH_AUTH_SOCK" ]]; then
    ORIG_SSH_AUTH_SOCK="$(readlink ~/.ssh/ssh_auth_sock)"
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    # restore the original value when this shell exits
    trap restore_orig_ssh_auth_sock EXIT
    function restore_orig_ssh_auth_sock() {
        # There are lots of different scenarios, when there are concurrent logins.
        # It's not always clear which is the newest/best $SSH_AUTH_SOCK to use.
        [ -e "$ORIG_SSH_AUTH_SOCK" ] && ln -sf "$ORIG_SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    }
fi


# make less be able to open up tar files and gzip files
type -p lesspipe >/dev/null   &&   eval "$(SHELL=/bin/sh lesspipe)"


[ -f ~/.bash_aliases ]   &&   source ~/.bash_aliases


# GNU stow
alias rel2abs='perl -MCwd -e "print Cwd::abs_path shift"'
mkdir -p ~/apps/stow/
mkdir -p ~/apps/build/
[ -d ~/apps/stow ]                 && export STOW_DIR=$(rel2abs $HOME/apps/stow)


# PerlBrew and local::lib
[ -d ~/perl5 ]                     && export PERL_CPANM_OPT="--local-lib=~/perl5"
[ -d ~/perl5/bin ]                 && export PATH=~/perl5/bin:$PATH
[ -f ~/perl5/lib/perl5/local/lib.pm ] && perl -le 'exit 1 unless $^V ge v5.8.1' && eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
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


# workaround for menu not appearing
#   https://bugs.launchpad.net/ubuntu/+source/vim/+bug/771810
#   https://bugs.launchpad.net/ubuntu/+source/vim/+bug/776499
function gvim {
    command gvim -f "$@" >/dev/null 2>/dev/null &
    disown
}
