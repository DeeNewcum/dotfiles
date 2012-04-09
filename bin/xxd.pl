#!/usr/bin/env perl

# do a hex-dump, similar to "xxd", for machines that don't/can't install it

        use strict;
        use warnings;

my @fill = ("  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ");

hexdump(*STDIN) unless @ARGV;
foreach my $file (@ARGV) {
    print "File: ", $file, "\n";
    open my $fin, '<', $file    or die "Unable to open $file: $!\n";
    hexdump($fin);
    close $fin;
}

sub hexdump {
    my $fin = shift;
    my $i;
    while (my $rb = read($fin, my $buf, 16)) {
        my @x = unpack("H2" x $rb, $buf);
        $buf =~ s/[\x00-\x1f\x7f-\xff]/./g;
        $buf .= ' ' x (16-length($buf));
        printf "%06x0: %s  %s\n",
            $i++,
            sprintf ("%s%s %s%s %s%s %s%s %s%s %s%s %s%s %s%s", @x, @fill),
            $buf;
    }
}

