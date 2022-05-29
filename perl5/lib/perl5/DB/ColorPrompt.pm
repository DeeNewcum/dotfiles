package DB::ColorPrompt;

our $VERSION = 0.01;

=pod

=head1 NAME

DB::ColorPrompt - Use ANSI colors to hilight your perl5db.pl prompt.

=head1 SYNOPSIS

In your F<~/.perldb> file, add this:

 use DB::ColorPrompt 'on_blue';

Any L<Term::ANSIColor> color sequence works.

=head1 DESCRIPTION

When used alongside the L<perldebug|default debugger>, this provides the ability
to hilight the prompt in the given color.

=head1 AUTHOR

Dee Newcum <deenewcum@cpan.org>

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

use strict;
use warnings;

use Carp;                       # core Perl, as of Perl 5.000
use Term::ANSIColor 2.02 ();    # core Perl, as of Perl 5.6.0

our $main_color;        # the color we use when there's no typeahead
our $typeahead_color;   # the color we use when there is typeahead

my $original_readline = \&DB::readline;

sub import {
    my $class = shift;

    if (@_) {
        $main_color = shift;
        if (!Term::ANSIColor::colorvalid($main_color)) {
            carp "'$main_color' isn't a valid color attribute per Term::ANSIColor";
            # Normally perl5db.pl fastidiously avoids exiting. Tell it to stop
            # doing that and actually let us exit.
            $DB::inhibit_exit = 0;
            exit(1);
        }

        if (@_) {
            $typeahead_color = shift;
            if (!Term::ANSIColor::colorvalid($typeahead_color)) {
                carp "'$typeahead_color' isn't a valid color attribute per Term::ANSIColor";
                # Normally perl5db.pl fastidiously avoids exiting. Tell it to
                # stop doing that and actually let us exit.
                $DB::inhibit_exit = 0;
                exit(1);
            }
        } else {
            # default values
            $typeahead_color = 'blue';
        }
    } else {
        # default values
        $main_color = 'on_blue';
        $typeahead_color = 'blue';
    }

    # monkey-patch the DB::readline() function
    no warnings 'redefine';
    *DB::readline = \&DB::ColorPrompt::readline;
}


sub readline {
    my ($prompt) = @_;

    # Usually there's a space at the end of the prompt. If it's there, then
    # avoid coloring it.
    my $append = '';
    if ($prompt =~ s/( )$//) {
        $append = $1;
    }

    if (@DB::typeahead) {
        if (defined($typeahead_color)) {
            return $original_readline->(
                Term::ANSIColor::colored($prompt, $typeahead_color)
                . $append);
        } else {
            return $original_readline->($prompt . $append);
        }
    } else {
        if (defined($main_color)) {
            return $original_readline->(
                Term::ANSIColor::colored($prompt, $main_color)
                . $append);
        } else {
            return $original_readline->($prompt . $append);
        }
    }
}

1;
