xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'          # Caps-lock works as an Escape key

[ -d $HOME/.cache/sessions ] && rm -rf $HOME/.cache/sessions        # prevent applications from being saved and auto-started in Xfce4
