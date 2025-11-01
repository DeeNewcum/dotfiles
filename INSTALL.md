# additional install steps

## Perl modules

If you're on Cygwin, do this:

```
# Using the normal Cygwin installer, double-check that the 'wget' package is installed.

# Make sure apt-cyg is installed:
install_apt-cyg

# If cpanm isn't installed yet:
cpan install App::cpanminus

# These install more easily in their Cygwin packaged form, rather than through CPAN.
apt-cyg install perl-libwww-perl perl-Module-Build perl-Readonly perl-Params-Util perl-TermReadKey
```

Then, run this on all systems:

```
cpanm LWP::UserAgent Term::ReadKey Module::Build CGI Data::Dumper::Simple Perl::Metrics::Simple
```



