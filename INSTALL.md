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

If you're on some other Unix system, run these instead:

```
cpanm LWP Module::Build Readonly Params::Util Term::ReadKey
```


Then, run this, regardless of what system you're on:

```
cpanm CGI Data::Dumper::Simple Log::Dispatch LWP::UserAgent Module::Build Perl::Metrics::Simple Term::ReadKey
```



