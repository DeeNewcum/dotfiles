#!/usr/bin/env perl

# Solaris's tail doesn't have the -s option, so you can't do the uber-useful `tail -fs0`.
# This duplicates that functionality.
#
# Further, this allows you to do real-time sed/grep things to do the output, which is otherwise
# difficult to do in an unbuffered manner.
# (to do this, make a copy of the script, and change the "SED/GREP" line below)


    use strict;
    use warnings;


my $filename = shift    or die "Specify a filename to tail -f.\n";

open FIN, "<$filename"      or die $!;
seek(FIN, -1000, 2);
tell(FIN)  and do {my $throwaway = <FIN>};      # don't throw the line away if we're at the beginning of the file


my $curpos;
for (;;) {
    for ($curpos = tell(FIN); <FIN>; $curpos = tell(FIN)) {
        ## DO SED/GREP/ETC THINGS HERE, if needed
        print $_;
    }
    # sleep for a while
    select undef, undef, undef, 0.1;
    seek(FIN, $curpos, 0);  # seek to where we had been
}
