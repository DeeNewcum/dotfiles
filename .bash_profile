# .bash_profile is for login shells, .bashrc is for interactive non-login shells


# ========  load ~/.sudo_bashrc  ========
export STDIN_OWNERS_HOME=$(perl -e'print((getpwuid((stat shift)[4]))[7])' $(tty))
#       [ -f $STDIN_OWNERS_HOME/.sudo_bashrc ] && source $STDIN_OWNERS_HOME/.sudo_bashrc


[ -f ~/.bashrc ] && source ~/.bashrc



