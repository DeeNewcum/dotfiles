# .bash_profile is for login shells, .bashrc is for interactive non-login shells


# ========  load ~/.sudo_bashrc  ========
export STDIN_OWNERS_HOME=$(eval echo ~$(who am i | cut -d ' ' -f 1))
#       [ -f $STDIN_OWNERS_HOME/.sudo_bashrc ] && source $STDIN_OWNERS_HOME/.sudo_bashrc


[ -f ~/.bashrc ] && source ~/.bashrc



