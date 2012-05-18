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


my $ansi = do { local $/ = undef; <STDIN>};
my $html = ansi2html($ansi);
print $html;
exit;





sub ansi2html {
    my ($ansi) = @_;
    
    ## tokenize
    my @tokens = split /
            (                           # preserve the delimeters
              \e[^a-z]*[a-z]            # an escape sequence
            |                           # a markdown-like header
              (?:\x0d\x0a|\x0d|0x0a|^)  # start at the beginning of a line
              (?:==|\#\#)               # markdown line can start with == or ##
              [^\n\r]+
            )
        /six, $ansi;
    #die Dumper [ map {s/\e/<ESC>/gs; $_} @tokens ];
        
    ## generate output
    my $html = '';


    my ($fg, $bg, $bold, $underline);
    my $last_class = '';
    my @sections;
    foreach my $tok (@tokens) {
         if ($tok =~ /^\e\[(.*)m$/s) {
            my $attribs = $1;
            $attribs = "0"  if (length($attribs) == 0);             # \e[m   is the same as    \e[0m     ?
            $html .= "</span>" if (defined($fg) || defined($bg));
            foreach my $attrib (split /;/, $attribs) {
                if ($attrib =~ /^\d+$/ && $attrib == 0) {
                    $html .= "</b>"        if ($bold);
                    $html .= "</u>"        if ($underline);
                    $fg = undef;
                    $bg = undef;
                    $bold = 0;
                    $underline = 0;
                } elsif ($attrib == 1) {
                    $bold = 1;
                    $html .= "<b>";
                } elsif ($attrib == 4) {
                    $underline = 1;
                    $html .= "<u>";
                } elsif ($attrib == 7) {
                    ($fg, $bg) = ($bg, $fg);
                } elsif ($attrib >= 30 && $attrib <= 37) {
                    $fg = $attrib - 30;
                } elsif ($attrib >= 90 && $attrib <= 97) {
                    $fg = $attrib - 90 + 8;
                } elsif ($attrib >= 40 && $attrib <= 47) {
                    $bg = $attrib - 40;
                } elsif ($attrib >= 100 && $attrib <= 107) {
                    $bg = $attrib - 100 + 8;
                }
            }
            #printf STDERR "%-10s fg = %s   bg = %s\n", $attribs, u($fg), u($bg);
            if (defined($fg) || defined($bg)) {
                my @class;
                push(@class, "f$fg")        if (defined($fg));
                push(@class, "b$bg")        if (defined($bg));
                $last_class = join(" ", @class);
                $html .= "<span class='$last_class'>";
                #printf STDERR "%-20s %s\n", $attribs, join(" ", @class);
            } else {
                $last_class = '';
            }

       } elsif ($tok =~ /^\e/s) {
            ## unrecognized escape code -- ignore?

            ## TODO: recognize the xterm title, and hide all text between the start and end sequences
    
       } elsif ($tok =~ /^[\n\r]*(==+)([^\n\r]*)==[\n\r]*$/s
             || $tok =~ /^[\n\r]*(##+)([^\n\r]*)##[\n\r]*$/s
       ) {
            ## a markdown-like section header
            my ($level, $header) = ($1, $2);
            my $char = substr($level,0,1);
            $level = length($level) - 1;
            $header =~ s/$char+$//s;
            $header =~ s/^\s+|\s+$//sg;

            push(@sections, {
                    level  => $level,
                    text   => $header,
                    anchor => 'sec' . (scalar(@sections) + 1),
                });

            $html .= "<a name='$sections[-1]{anchor}' />";

            #print STDERR "<h$level>$header</h$level>\n";

            # headers with '=' and '#' are exactly the same from a table-of-contents standpoint...
            # the only difference is that '#' headers don't actually display anything in the body...  they're an <a name=...> only
            if ($char eq '=') {
                $html .= "</pre>\n<h$level>" . CGI::escapeHTML($header) . "</h$level>\n<pre>";
                $html .= "<span class='$last_class'>"       if ($last_class);       # reinstantiate the color that was there before
            }


       } else {
            my $print = CGI::escapeHTML($tok);

            ## what should we do with backspaces?
            #$print =~ s/\x08/^H/sg;         ## display them
            $print =~ s/\x08//sg;           ## hide them, but leave other characters
                    ## TODO: erase the previous characters

            $html .= $print;
        }
    }

    my $preamble = join("", <DATA>);       ## HTML preamble

    if (@sections) {
        #print STDERR Dumper \@sections;
        $preamble .= "\n\n<div class=toc>\n<b>Table of contents</b>\n";
        my $curlevel = 0;
        foreach my $sect (@sections) {
            my $lvl_diff = $sect->{level} - $curlevel;
            if ($lvl_diff > 0) {
                $preamble .= "<ul>"x$lvl_diff;
            } elsif ($lvl_diff < 0) {
                $preamble .= "</ul>"x-$lvl_diff;
            }
            $curlevel = $sect->{level};
            $preamble .= "<li><a href='#$sect->{anchor}'>" . CGI::escapeHTML($sect->{text}) . "</a>\n";
        }
        $preamble .= "</ul>"x$curlevel;
        $preamble .= "</div>\n\n";
    }

    $html = $preamble . "<pre>" . $html;

    return $html;
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

/* --==##  Table of Contents distinctive styling  ##==-- */
div.toc {margin-left:4em; background-color:#ddd; padding:0.3em; border:1px solid #fff; display:inline-block; color:#000}

/* --==##  links aren't underlined unless you :hover  ##==-- */
a:link:hover {text-decoration:underline}
a {text-decoration:none}
@media print { a:link {text-decoration:underline} }

/* --==##  make h1/h2/h3 stand out rounded centered blobs  ##==-- */
h1, h2, h3 {
    border:2px solid #fff;
    background-color:#888;
    color:           #000;
    padding:0.3em 2em;
    -moz-border-radius: 5em;
    border-radius: 5em;
    margin-top:2em;
    text-align:center;
    /* http://pmob.co.uk/pob/centred-float.htm */
    float:right;
    position:relative;
    left:-50%;
    text-align:left;
}
pre {clear:both}

</style>
<body class="b0 f15">
