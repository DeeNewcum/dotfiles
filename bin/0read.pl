#!/usr/bin/perl

# The opposite of 0print. This script reads in relatively unformatted
# text from some other process, and tries to create a file list out of it.
#
# This script may do some extra work to try to "do the right thing", as it were.
#           What is the "right thing"? https://ell.stackexchange.com/a/27146

    use strict;
    use warnings;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements

print "hello world\n";

print Dumper ["hello", "world"];
