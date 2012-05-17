#!/usr/bin/perl

# a rewrite of http://www.pixelbeat.org/scripts/ansi2html.sh
#
# but the ANSI code behavior is more similar to gnome-terminal / libVTE
#               https://www.ohloh.net/p/vte

    use strict;
    use warnings;

    use CGI;
    #use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


## read in file, and tokenize
my @tokens = split /(\e[^a-z]*[a-z])/si, do { local $/ = undef; <STDIN>};


#die Dumper [ map {s/\e/<ESC>/gs; $_} @tokens ];



print <DATA>;

my ($fg, $bg, $bold, $underline);
foreach my $tok (@tokens) {
    if ($tok !~ /^\e/s) {
        my $print = CGI::escapeHTML($tok);
        #$print =~ s/\x08/^H/sg;
        $print =~ s/\x08//sg;
        print $print;
    } elsif ($tok =~ /^\e\[(.*)m$/s) {
        my $attribs = $1;
        $attribs = "0"  if (length($attribs) == 0);             # \e[m   is the same as    \e[0m     ?
        print "</span>" if (defined($fg) || defined($bg));
        foreach my $attrib (split /;/, $attribs) {
            if ($attrib =~ /^\d+$/ && $attrib == 0) {
                print "</b>"        if ($bold);
                print "</u>"        if ($underline);
                $fg = undef;
                $bg = undef;
                $bold = 0;
            } elsif ($attrib == 1) {
                $bold = 1;
                print "<b>";
            } elsif ($attrib == 4) {
                $underline = 1;
                print "<u>";
            } elsif ($attrib == 7) {
                ($fg, $bg) = ($bg, $fg);
                #print "\t-- $attrib = fg $fg    bg $bg\n";
            } elsif ($attrib >= 30 && $attrib <= 37) {
                $fg = $attrib - 30;
                #print "\t-- $attrib = fg $fg\n";
            } elsif ($attrib >= 90 && $attrib <= 97) {
                $fg = $attrib - 90 + 8;
                #print "\t-- $attrib = fg $fg\n";
            } elsif ($attrib >= 40 && $attrib <= 47) {
                $bg = $attrib - 40;
                #print "\t-- $attrib = bg $bg\n";
            } elsif ($attrib >= 100 && $attrib <= 107) {
                $bg = $attrib - 100 + 8;
                #print "\t-- $attrib = bg $bg\n";
            }
        }
        #printf "%-10s fg = %s   bg = %s\n", $attribs, u($fg), u($bg);
        if (defined($fg) || defined($bg)) {
            my @class;
            push(@class, "f$fg")        if (defined($fg));
            push(@class, "b$bg")        if (defined($bg));
            print "<span class='", join(" ", @class), "'>";
            #printf "%-20s %s\n", $attribs, join(" ", @class);
        }
    } else {
        # ignore?
    }
}



sub u { defined($_[0]) ? $_[0] : 'undef' }


__DATA__
<style>
.f0  { color: #000000 } .b0  { background-color: #000000 }
.f1  { color: #CD0000 } .b1  { background-color: #CD0000 }
.f2  { color: #00CD00 } .b2  { background-color: #00CD00 }
.f3  { color: #CDCD00 } .b3  { background-color: #CDCD00 }
.f4  { color: #0000EE } .b4  { background-color: #0000EE }
.f5  { color: #CD00CD } .b5  { background-color: #CD00CD }
.f6  { color: #00CDCD } .b6  { background-color: #00CDCD }
.f7  { color: #E5E5E5 } .b7  { background-color: #E5E5E5 }
.f8  { color: #7F7F7F } .b8  { background-color: #7F7F7F }
.f9  { color: #FF0000 } .b9  { background-color: #FF0000 }
.f10 { color: #00FF00 } .b10 { background-color: #00FF00 }
.f11 { color: #FFFF00 } .b11 { background-color: #FFFF00 }
.f12 { color: #5C5CFF } .b12 { background-color: #5C5CFF }
.f13 { color: #FF00FF } .b13 { background-color: #FF00FF }
.f14 { color: #00FFFF } .b14 { background-color: #00FFFF }
.f15 { color: #FFFFFF } .b15 { background-color: #FFFFFF }
</style>
<body class="b0 f15"><pre>
