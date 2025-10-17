# additional install steps

## Perl modules

If you're on Cygwin, do this:

```
# Using the normal Cygwin installer, double-check that the 'wget' package is installed.

# If apt-cyg isn't installed yet:
wget -O /tmp/apt-cyg https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
install /tmp/apt-cyg /bin

# If cpanm isn't installed yet:
cpan install App::cpanminus

# These install more easily in their Cygwin packaged form, than through CPAN.
apt-cyg install perl-libwww-perl perl-Module-Build perl-Readonly perl-Params-Util perl-TermReadKey
```

Then, on all systems:

```
cpanm LWP::UserAgent Term::ReadKey Module::Build CGI Data::Dumper::Simple Perl::Metrics::Simple
```



