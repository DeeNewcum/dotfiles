#!/bin/bash

# about libevent -- https://en.wikipedia.org/wiki/Libevent

# --==##  dependencies  ##==--
#
# on CentOS, you need to install openssl first (specifically the file 'openssl.pc')


set -x

SKIPTO=${1:-0}      # allow for primitive 'make'-like functionality, by allowing the user to specify a line to skip ahead to

# check what the latest release is at https://github.com/libevent/libevent/releases
export VERSION=2.1.12-stable


                                mkdir -p ~/apps/build
                                mkdir -p ~/apps/stow
                                cd ~/apps/build
[ $SKIPTO -le $LINENO ] &&      [ -f libevent-$VERSION.tar.gz ] || wget -N https://github.com/libevent/libevent/releases/download/release-$VERSION/libevent-$VERSION.tar.gz
[ $SKIPTO -le $LINENO ] &&      tar -xvzf libevent-$VERSION.tar.gz

                                cd ~/apps/build/libevent-$VERSION

[ $SKIPTO -le $LINENO ] &&      ./configure --prefix="$HOME/apps/stow/libevent-$VERSION"

echo 'THIS SCRIPT IS NOT COMPLETE' >2
