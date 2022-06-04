package CGI::Carp::warningsToBrowser;

our $VERSION = 0.01;

=pod

=head1 NAME

CGI::Carp::warningsToBrowser - A version of L<CGI::Carp>'s warningsToBrowser()
that displays the warnings loudly and boldy

=head1 SYNOPSIS

Put this at the top of your CGI script (the earlier the better, otherwise some
warnings won't be captured):

 use CGI::Carp::warningsToBrowser;

Warnings will now be displayed at the very top of the web page, rather than
hidden in HTML comments like L<CGI::Carp>'s version.  This is intended mainly
for dev and test environments, not for prod, so it's a good idea to use L<if>:

 use if $is_dev, 'CGI::Carp::warningsToBrowser';

The author feels that it's important to expose warnings early in the software
development lifecycle, as part of the "L<shift
left|https://devopedia.org/shift-left>" effort.

=head1 ERRORS

This module does not handle fatal errors. The author feels that L<CGI::Carp>
does an adequate job at accomplishing that task.

=head1 AUTHOR

Dee Newcum <deenewcum@cpan.org>

=head1 CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome.

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

use strict;
use warnings;

use HTML::Entities ();

our @WARNINGS;

sub import {
    # if we're under the debugger, don't interfere with the warnings
    return if (exists $INC{'perl5db.pl'} && $DB::{single});
    # if we're under perl -c, don't interfere with the warnings
    return if ($^C);
    $main::SIG{__WARN__} = \&_handle_warn;
}


sub _handle_warn {
    push @WARNINGS, shift;
}


END {
    _print_warnings();
}


sub _print_warnings {
    return unless (@WARNINGS);
    # TODO: Hopefully we have output a text/html document. Is there a way to
    # detect this, and avoid printing on other kinds of documents (which could
    # corrupt file downloads, for example)
    #       see -- Tie::StdHandle or Tie::Handle::Base

    # TODO: What do we do about encoding? Is there a way to auto-detect what
    # kind of encoding was specified? Or should we just use
    # Unicode::Diacritic::Strip (to strip diacritics) and/or Text::Unidecode (to
    # output string-representations of non-ASCII Unicode characters)?
    #       see -- Tie::StdHandle or Tie::Handle::Base

    # In some situations, the HTTP response header won't have been output yet.
    # Try to auto-detect this.
    my $bytes_written = tell(STDOUT);
    if (!defined($bytes_written) || $bytes_written <= 0) {
        # The HTTP response header *probably* hasn't been output yet, so output
        # one of our own.
        # (though see https://perldoc.perl.org/functions/tell for caveats)
        print STDOUT "Status: 500\n";
        print STDOUT "Content-type: text/html\n\n";
    }

    # print the warning-header
    print <<'EOF';
    <div id="CGI::Carp::warningsToBrowser" style="background-color:#faa; border:1px solid #000; padding:0.3em; margin-bottom:1em">
    <b>Perl warnings</b>
    <pre style="font-size:85%">
EOF
    foreach my $warning (@WARNINGS) {
        print HTML::Entities::encode_entities($warning);
    }

    # print the warning-footer
    print <<'EOF';
</pre></div>
<!-- move the warnings <div> to the very top of the document -->
<script type="text/javascript">
    var warningsToBrowser_pre = document.getElementById('CGI::Carp::warningsToBrowser');
    if (warningsToBrowser_pre) {
        warningsToBrowser_pre.remove();
        document.body.prepend(warningsToBrowser_pre);
    }
</script>
EOF
}

1;
