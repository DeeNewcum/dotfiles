#!/bin/bash

# download source tarball from https://ftp.gnu.org/gnu/screen/
#
# known to work with GNU Screen versions -- 4.9.0, (TODO)

set -x

[ -e Makefile ] && make realclean       # in case we're re-running this script

./autogen.sh                                    || exit
./configure --prefix=$HOME/apps/screen/         || exit
./config.status                                 || exit
make                                            || exit
make install                                    || exit

cd $HOME/apps/screen/;  find -type f -exec ls -l {} \;
