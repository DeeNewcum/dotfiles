#!/usr/bin/sh

# Installs https://github.com/jhspetersson/fselect


sudo wget -qO /usr/local/bin/fselect.gz https://github.com/jhspetersson/fselect/releases/latest/download/fselect-x86_64-linux-musl.gz

sudo gunzip /usr/local/bin/fselect.gz

sudo chmod a+x /usr/local/bin/fselect

fselect --version
