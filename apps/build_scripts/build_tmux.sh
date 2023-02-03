#!/bin/bash

    # vim: set number tw=0:

# Prerequisites on Debian:
#       sudo apt-get install libevent-dev
#
# On CentOS, when you don't own root...    well....  libevent isn't too hard to
# install, and it doesn't have any dependencies of its own.
#		https://en.wikipedia.org/wiki/Libevent
#		https://github.com/libevent/libevent/releases


set -x

SKIPTO=${1:-0}      # allow for primitive 'make'-like functionality, by allowing the user to specify a line to skip ahead to

# check what the latest release is at https://github.com/tmux/tmux/releases
export VERSION=3.3


                                mkdir -p ~/apps/build
                                mkdir -p ~/apps/stow
                                cd ~/apps/build
[ $SKIPTO -le $LINENO ] &&      [ -f tmux-$VERSION.tar.gz ] || wget -N https://github.com/tmux/tmux/releases/download/$VERSION/tmux-$VERSION.tar.gz
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
