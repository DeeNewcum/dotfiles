#!/bin/bash

    # vim: set number tw=0:

# Prerequisites on Debian:
#       sudo apt-get install libevent-dev
#

set -x

SKIPTO=${1:-0}      # allow for primitive 'make'-like functionality, by allowing the user to specify a line to skip ahead to

export VERSION=1.6


                                mkdir -p ~/apps/build
                                mkdir -p ~/apps/stow
                                cd ~/apps/build
[ $SKIPTO -le $LINENO ] &&      [ -f tmux-$VERSION.tar.gz ] || wget -N http://downloads.sourceforge.net/tmux/tmux-$VERSION.tar.gz
[ $SKIPTO -le $LINENO ] &&      tar -xvzf tmux-$VERSION.tar.gz

                                cd ~/apps/build/tmux-$VERSION

[ $SKIPTO -le $LINENO ] &&      ./configure --prefix="$HOME/apps/stow/tmux-$VERSION"



# .........
exit
# .........

[ $SKIPTO -le $LINENO ] &&      make
[ $SKIPTO -le $LINENO ] &&      make install

                                cd ~/apps/build
[ $SKIPTO -le $LINENO ] &&      rm tmux-$VERSION.tar.gz

                                stow tmux-$VERSION
