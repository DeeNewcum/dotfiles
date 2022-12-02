#!/bin/bash

# install the files from https://github.com/garabik/grc
#
# (NOTE: There are TWO tools with similar names and functionality:
#       - "generic coloUriSer" by Radovan Garabik
#       - "generic coloriZer" by Michel Albert
# They are completely different tools, and this script focuses on the first one.)

set -x

# Step 1 -- Download the latest version and unzip into /tmp/grc-master/.
cd /tmp
rm -rf /tmp/grc-master/
wget https://github.com/garabik/grc/archive/refs/heads/master.zip
unzip master.zip
rm -f master.zip

# Step 2 -- At this point, we could use the zip's install.sh script, but it doesn't get us much. 
#           Just do the install ourselves.
mkdir -p ~/.grc/
rm -f -- ~/.grc/*
cp -rpv /tmp/grc-master/colourfiles/* ~/.grc/
cp -pv /tmp/grc-master/{grc,grcat}.1 ~/man/man1/
if type -p python3 > /dev/null; then
    cp -pv /tmp/grc-master/{grc,grcat} ~/apps/bin/
else
    # fall back to python2
    sed 's#/usr/bin/env python3#/usr/bin/env python2#' /tmp/grc-master/grc   > ~/apps/bin/grc
    sed 's#/usr/bin/env python3#/usr/bin/env python2#' /tmp/grc-master/grcat > ~/apps/bin/grcat
fi
chmod +x ~/apps/bin/{grc,grcat}
