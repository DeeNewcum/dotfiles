#!/usr/bin/perl


    use strict;
    use warnings;

    use Cwd 'abs_path';
    use File::Basename;
    # an improved version of 'use FindBin'
    BEGIN {$FindBin::Bin = dirname( abs_path $0 );}

    use File::Find;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements



chdir $FindBin::Bin;


# run through all files/directories under ~/dotfiles/
find { wanted => sub {
    s/^\.\///;

    # directories to avoid altogether
    if ($_ eq '.git') {
        $File::Find::prune++;
        return;
    }

    # files to skip
    return if ($_ eq '.' || $_ eq 'README.creole' || $_ eq 'setup.pl');
    return if /\.swp$/;
    
    if (-d $_) {
        # if it's a directory, create that path under $HOME
        _mkdir($_);

    } elsif (-f $_) {
        # if it's a file, symlink it to $HOME
        if (/\.subst$/) {
            _substitute($_);
        } else {
            _symlink($_);
        }
    }
}, no_chdir=>1}, ".";


if ($ENV{USER} =~ /^[p][h][r][8][4][3]$/) {
    # in some cases, I want to make sure the checkin attribution is correct
    system "git", "config", "user.name", "Dee Newcum";
    system "git", "config", "user.email", 'dee.newcum@gmail.com';
}



sub _mkdir {
    my ($dir) = @_;

    return if (-d "$ENV{HOME}/$dir");

    if (-e "$ENV{HOME}/$dir" && !-d "$ENV{HOME}/$dir") {
        print "ERROR: Unable to create directory '$dir' because something is in the way.\n";
        return;
    }

    system "mkdir", "-p", "$ENV{HOME}/$dir";

    if (-d "$ENV{HOME}/$dir") {
        #print "created   $dir\n";
    } else {
        print "ERROR: unable to create directory '$dir'\n";
    }
}


sub _symlink {
    my ($file) = @_;

    my $to   = "$ENV{HOME}/$file";
    my $from = "$FindBin::Bin/$file";

    if (! -e $to) {
        symlink $from, $to;
        #print "creating symlink    $from     to    $to\n";
    } else {
        if (-l $to) {
            if (readlink($to) ne $from) {
                unlink $to;
                symlink $from, $to;
                #print "creating symlink    $from     to    $to\n";
            }
        } else {
            print "WARNING: ~/$file  already exists\n";
        }
    }
}


sub _substitute {
    my ($file) = @_;

    warn "_substitute($file) not yet implemented\n";
}
