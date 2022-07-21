#!/bin/bash

    # vim: set number tw=0:

# Prerequisites on Debian:
#       sudo apt-get install ncurses-dev xorg-dev libgtk2.0-dev
#

set -x

SKIPTO=${1:-0}      # allow for primitive 'make'-like functionality, by allowing the user to specify a line to skip ahead to


# whatever the latest version is
VER=2.2.0

                                mkdir -p ~/apps/bin
                                mkdir -p ~/apps/build
                                cd ~/apps/build
[ $SKIPTO -le $LINENO ] &&      wget -N http://ftp.gnu.org/gnu/stow/stow-$VER.tar.bz2
[ $SKIPTO -le $LINENO ] &&      tar -xvjf stow-$VER.tar.bz2

                                cd ~/apps/build/stow-$VER

[ $SKIPTO -le $LINENO ] &&      ./configure --with-pmdir=$HOME/dotfiles/perl5/lib/perl5 --prefix=$HOME/dotfiles/apps
[ $SKIPTO -le $LINENO ] &&      make install
[ $SKIPTO -le $LINENO ] &&      rm -rf ~/dotfiles/apps/share/doc/stow/
[ $SKIPTO -le $LINENO ] &&      rm ~/dotfiles/apps/share/info/stow.info
[ $SKIPTO -le $LINENO ] &&      rm ~/dotfiles/apps/share/info/dir

                                cd ~/apps/build
[ $SKIPTO -le $LINENO ] &&      rm stow-$VER.tar.bz2
