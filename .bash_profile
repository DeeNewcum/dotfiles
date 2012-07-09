# .bash_profile is for login shells, .bashrc is for interactive non-login shells


export STDIN_OWNERS_HOME=$(perl -e'print((getpwuid((stat shift)[4]))[7])' $(tty))

if [[ "$(uname)" == "Linux" && "$(tty)" == "/dev/tty"* ]]; then
    export IS_VIRTUAL_CONSOLE=1

    # use capslock as escape
    if perl -le 'exit 1 if qx[dumpkeys] =~ /keycode\s+58 = Escape/' 2>/dev/null; then
        (echo `dumpkeys | grep -i keymaps`; echo keycode 58 = Escape) | sudo loadkeys -
    fi
fi

[ -f ~/.bashrc ] && source ~/.bashrc
