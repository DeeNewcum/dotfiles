# .bash_profile is for login shells, .bashrc is for interactive non-login shells


if [[ "$(uname)" == "Linux" && "$(tty)" == "/dev/tty"* ]]; then
    export IS_VIRTUAL_CONSOLE=1

    # In X, we use .Xmodmap to remap capslock=>escape.  At the Virtual Console, we have
    # to use loadkeys.
    if perl -le 'exit 1 if qx[dumpkeys] =~ /keycode\s+58 = Escape/' 2>/dev/null; then
        echo [sudo] Modifying console key mapping
        (echo `dumpkeys | grep -i keymaps`; echo keycode 58 = Escape) | sudo loadkeys -
    fi
            # ^^ If you want to be able to login at the console without having to type
            #    your password twice, run this:
            #           echo "$USER ALL = (root) NOPASSWD: /usr/bin/loadkeys" | sudo 'cat >> /etc/sudoers'
fi

[ -f ~/.bashrc ] && source ~/.bashrc
