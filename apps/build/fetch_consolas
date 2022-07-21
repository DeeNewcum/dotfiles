#!/bin/bash

# fetch this font:
#       http://en.wikipedia.org/wiki/Consolas
#
#
# prerequisites:
#       - have 7z installed
#                   debian package:     p7zip-full



# download PowerPoint Viewer 2007
#           http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=6
cd /tmp/
wget -N http://download.microsoft.com/download/f/5/a/f5a3df76-d856-4a61-a6bd-722f52a5be26/PowerPointViewer.exe

7z -y e PowerPointViewer.exe ppviewer.cab

mkdir /tmp/Consolas
cd /tmp/Consolas
7z -y e /tmp/ppviewer.cab CONSOLA.TTF CONSOLAB.TTF CONSOLAI.TTF CONSOLAZ.TTF 

echo -e "\n\nThe *.ttf files have been placed in /tmp/Consolas"

# cleanup
rm /tmp/ppviewer.cab /tmp/PowerPointViewer.exe
