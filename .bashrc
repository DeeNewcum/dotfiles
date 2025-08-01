# .bashrc is for interactive non-login shells, .bash_profile is for login shells
[ -z "$PS1" ] && return


# $PATH
[ -d ~/bin/ ]      && export PATH=$HOME/bin:$PATH
[ -d ~/apps/bin/ ] && export PATH=~/apps/bin/:$PATH     # custom-compiled apps that override the system ones


# prompt
PROMPT_HOSTNAME='\h'
[ -e ~/.short_hostname_override ] && PROMPT_HOSTNAME="$(cat ~/.short_hostname_override)"
XTERM_TITLE='\[\033]0;'$PROMPT_HOSTNAME'\007\]'
[ "$IS_VIRTUAL_CONSOLE" ] && XTERM_TITLE=''         # don't use the Xterm title when at the Linux Virtual Console
# The "fancy" version of my prompt.
#PS1=$XTERM_TITLE'\[\033[01;32m\]\u@'$PROMPT_HOSTNAME'\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # Note: As suggested by:
    #           http://tldp.org/HOWTO/Bash-Prompt-HOWTO/xterm-title-bar-manipulations.html
    #       we should only update the Xterm title when we're SURE that the end-user's terminal
    #       supports this feature.  Currently, all of mine do, and also my $TERM is an unreliable
    #       way to check if the end-user's terminal does.  So, for now, I'm always sending this.
# A less fancy prompt.
PS1="$XTERM_TITLE\[\033[7m\]\u@$PROMPT_HOSTNAME:\w \[\033[0m\] "


# vi mode
set -o vi
bind -m vi-insert \\C-l:clear-screen        # make Ctrl-L work the same as it does in emacs mode


# $EDITOR and $PAGER
type -p vim >/dev/null   &&   export EDITOR=vim
type -p less >/dev/null   &&   export PAGER='less -i'
#type -p vimpager >/dev/null   &&   type -p vim >/dev/null   &&   export PAGER=vimpager


# Make sure that ALL Bash history is recorded, even when there are multiple
# concurrent sessions by a person, different people su'd at the same time, etc.
history -r                  # read in existing history from the file
shopt -s histappend         # support multiple sessions / users
HISTSIZE=10000              # remember the last 10,000 commands
HISTFILESIZE=$HISTSIZE      # the differences between these two is confusing,
                            # see https://stackoverflow.com/q/19454837/1042525
HISTTIMEFORMAT="%F %T -- "  # timestamps are normally disabled; enable them
if [ -e "$HISTFILE"  -a  ! -w "$HISTFILE" ]; then
    echo
    echo -ne "\033[41m"     # red background
    echo -ne "\033[97m"     # bright white foreground
    echo -n  "ERROR: The permissions on $HISTFILE mean Bash history won't be saved."
    echo -e  "\033[0m"      # reset color
    echo
fi
# record extra info about this new login or new su
[ -n "$PS1" ] && history -s "# new shell -- Bash pid $BASHPID -- $(who am i)"
# for a more complex history solution, see https://unix.stackexchange.com/a/375092/52831


# more personalized tweaks to history
HISTIGNORE="&:ls:clear"


# https://github.com/DeeNewcum/termdetect
#if [ -e ~/git/termdetect/src/termdetect ]; then
#    export TERM=$(~/git/termdetect/src/termdetect -t)
#else
#    export TERM=$(termdetect -t)
#fi

# display
if [ -z "$DISPLAY" ]; then
    # avoid problems with git fetch / git pull on RHEL when $DISPLAY isn't set
    #           see more:  http://git.661346.n2.nabble.com/git-calls-SSH-ASKPASS-even-if-DISPLAY-is-not-set-td5825303.html
    unset SSH_ASKPASS
fi




# Quick-login -- Normally, after login, a script (or the user) would run just the alias 'q'. Which
# one of these it gets mapped to is up to the parent .bashrc.
function exec_screen {
    if command -v screen   2>&1 >/dev/null;   then
        # rejoin an existing session, if possible
        screen -U -dr main || screen -U -S main
        exit
    else
        >&2 echo "Error:  GNU Screen isn't installed here"
    fi
}

function exec_tmux {
    if command -v tmux   2>&1 >/dev/null;   then
        # rejoin an existing session, if possible
        exec tmux new -AD -s main
    else
        >&2 echo "Error:  tmux isn't installed here"
    fi
}

function q_not_set {
    cat <<EOF
No quick-login option has been chosen yet. Add one of these to your .bashrc:

    alias q=exec_tmux
    alias q=exec_screen
EOF
}


# It's expected that the parent .bashrc will overwrite this alias.
alias q=q_not_set



###################################################
#################  COLOR  #########################
###################################################
# enable color for as many things as possible

#export GREP_OPTIONS='--color=auto' 
alias grep='command grep --color=auto'

if [ "$(command ls --color 2>&1 >/dev/null)" ]; then
    alias ls='ls -F'
else
    alias ls='ls -F --color=auto'
fi

# $LS_COLORS
if type -p dircolors >/dev/null; then
    eval "$(dircolors -b)"

    function @tree { tree -C -F "$@" | less -RF; }
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

[ -f /etc/bash_completion ] && . /etc/bash_completion

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
################ GNU SCREEN  ######################
###################################################

# copied from https://brainscraps.fandom.com/wiki/Extreme_Multitasking_with_tmux_and_PuTTY

look_for_cmd=0
print_cmd() {
  if [ ${look_for_cmd} = 1 ] ;then
    if [ "${BASH_COMMAND}" != 'print_default' ] ;then
      if [ -z "$HISTTIMEFORMAT" ]; then
        cmdline=$(history 1 | xargs | cut -d\  -f2-)
      else
        cmdline=$(history 1 | xargs | cut -d\  -f5-)
      fi
      if [[ "${cmdline}" =~ ^(sudo|ssh|vi|vim|man|more|less)\  ]] ;then
        first=$(echo "${cmdline}" | awk '{print $1}')
        for i in ${cmdline} ;do
          if ! [[ "${i}" =~ ^-.*$ ]] && ! [[ "${i}" =~ ^${first}$ ]] ;then
            cmd=$(echo "${first} ${i}" | grep -o ".\{,30\}$")
            break
          fi
        done
      elif [[ "${cmdline}" =~ ^[A-Z]*=.*$ ]] ;then
        cmd=$(echo ${cmdline} | awk '{print $2}')
      else
        cmd=$(echo ${cmdline} | awk '{print $1}')
      fi
      echo -ne "\033k${cmd}\033"\\ 1>&2
      [ -n "$TMUX" ] && tmux rename-window "$cmd"
      look_for_cmd=0
    else
      return
    fi
  fi

  # show the current directory in the hardstatus
  #echo -en '\033]0;'$PWD'/\007'
}

print_default() {
  echo -ne "\033kbash\033"\\ 1>&2
      [ -n "$TMUX" ] && tmux rename-window "bash"
  look_for_cmd=1
}

# are we running underneath GNU Screen?
if is_under_gnu_screen; then
    PROMPT_COMMAND='print_default'

    trap "print_cmd" DEBUG
fi

###################################################
################### TMUX ##########################
###################################################

if [ -n "$TMUX" ]; then

    # set long hostname
    export HOSTNAME=$(hostname)
    [ -e ~/.hostname_override ] && HOSTNAME="$(cat ~/.hostname_override)"
    tmux setenv -g HOST "$HOSTNAME"

fi


###################################################
################### WORK ##########################
###################################################

# show the OS release date  (for my work machines, which are often very old)
if [ -e /etc/system-release-cpe ]; then
    # This only works on RHEL and CentOS machines.
    perl -e 'print "\e[41m" . "\e[1;37m" . "==== "'
    cat /etc/redhat-release | perl -pe 'chomp; s/Linux release //; s/Red Hat Enterprise/RHEL/; s/ \(\w+\)//; s/\.\d{4}$//'
    perl -e 'printf " was released %d years ago. ====" . "\e[0m" . "\n", (-M "/etc/system-release-cpe")/365'

    ## TODO: Some other options for getting the date include:
    ##
    ##      rpm -q --queryformat '%{RELEASE}' centos-release | perl -nle 'print $1 if /\b(20\d\d)\b/'
    ##
    ##      dnf repoquery --installed --queryformat '%{buildtime}' redhat-release
fi


function _updot_just_github {
    if [ -e ~/dotfiles/ ]; then
        pushd ~/dotfiles/       > /dev/null
        git pull --ff-only origin
        ./deedot
        popd        > /dev/null
    fi

}


# update both things -- do an automated 'git pull' followed by a ~/dotfiles/deedot
function _updot_work {
    if [ -e ~/dotfiles/ ]; then
        pushd ~/dotfiles/       > /dev/null
        git pull --ff-only origin
        popd        > /dev/null
    fi

    if [ -e /mnt/global/newcum ]; then
        /mnt/global/newcum/dotfiles-update_symlinks.pl

        pushd /mnt/global/newcum/UIC_dotfiles/      > /dev/null
        ./deedot
        popd        > /dev/null
    else
        pushd ~/dotfiles/       > /dev/null
        ./deedot
        popd        > /dev/null
    fi
}

# Pick one, the power is in your hands.
alias updot='_updot_work'
#alias updot='_updot_just_github'


###################################################
###################################################


if [ "$LOGNAME" = "root" ]; then
    # take care when overwriting things, if root
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
fi


~/bin/gnome__escape_capslock_swap     # swap caps-lock and escape


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
ROOTS_HOME="$( eval echo ~root )"
if [ "$HOME" != "$ROOTS_HOME" ]; then       # don't use local::lib for root
    [ -d ~/perl5 ]                     && export PERL_CPANM_OPT="--local-lib=~/perl5"
    [ -d ~/perl5/bin ]                 && export PATH=~/perl5/bin:$PATH
    [ -f ~/perl5/lib/perl5/local/lib.pm ] && perl -le 'exit 1 unless $^V ge v5.8.1' && eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
    [ -f ~/perl5/perlbrew/etc/bashrc ] && source ~/perl5/perlbrew/etc/bashrc
fi

# install all the 'fasd' aliases -- "a", "S", "sd","sf", "d", "f", "z", "zz", etc.
type -p fasd >/dev/null && eval "$(fasd --init auto)"


# https://asdf-vm.com/
[ -e $HOME/.asdf/asdf.sh ] && source $HOME/.asdf/asdf.sh
[ -e $HOME/.asdf/completions/asdf.bash ] && source $HOME/.asdf/completions/asdf.bash


# pip3
[ -e $HOME/.local/bin/ ] && export PATH="$PATH:$HOME/.local/bin/"


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



if [ "$(uname -o)" = "Cygwin" ]; then
    source ~/.bashrc_cygwin
fi


# `perl -d` won't work properly unless this file has the right permissions
[ -e ~/.perldb ] && chmod go-w ~/.perldb
