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
        print "setup    ~/$dir\n";
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
        print "setup    ~/$file\n";
    } else {
        if (-l $to) {
            if (readlink($to) ne $from) {
                unlink $to;
                symlink $from, $to;
                #print "creating symlink    $from     to    $to\n";
                print "setup    ~/$file\n";
            }
        } else {
            if (!scan_file_for_include_command($file)) {
                # If the above function returned false, that means it didn't notify the user about the status of the file.  So we'll use the fallback notification.
                print "WARNING: ~/$file  already exists\n";
            }
        }
    }
}


# Specific file types have the ability to '#include' or 'source' another file.
# 
# Here we scan through the file, line-by-line, checking if it has the specific command we're looking for.
#
# Returns true if this routine took care of notifying the user.
sub scan_file_for_include_command {
    my ($file) = @_;

    my %include_commands = map {s/^\s+|\s+$//sg; $_} split /[\n\r]+/, <<'EOF';
        .bash_aliases
                [ -f ${STDIN_OWNERS_HOME:-~}/<<HOMEPATH>> ] && source ${STDIN_OWNERS_HOME:-~}/<<HOMEPATH>>
        .bashrc
                [ -f <<PATH>> ] && source <<PATH>>
        .sudo_bashrc
                [ -f $STDIN_OWNERS_HOME/<<HOMEPATH>> ] && source $STDIN_OWNERS_HOME/<<HOMEPATH>>
        .vimrc
                source <<PATH>>
EOF
    #print Dumper \%include_commands; exit;

    return 0 unless (-e "$ENV{HOME}/$file");
    return 0 unless (exists $include_commands{$file});

    my $home_path = "$ENV{HOME}/$file";
    my $repo_path = "$FindBin::Bin/$file";

    my $lookingfor = $include_commands{$file};
    my $lookingfor_path = $repo_path;
    my $HOME = Cwd::abs_path($ENV{HOME});
    $lookingfor_path =~ s/^\Q$HOME\E/~/;
    $lookingfor =~ s/<<PATH>>/$lookingfor_path/g;
    if ($lookingfor =~ /<<HOMEPATH>>/) {
        my $lookingfor_homepath = $lookingfor_path;
        if ($lookingfor_homepath =~ s#^~/##) {
            $lookingfor =~ s/<<HOMEPATH>>/$lookingfor_homepath/g;
        } else {
            # It's impossible to use <<HOMEPATH>> in this case, because the $repo_path isn't anywhere under $ENV{HOME}
            # So show them the fallback error message.
            return 0;
        }
    }

    open my $fin, "<", $home_path       or die $!;
    while (<$fin>) {
        s/^\s+|\s+$//gs;        # chomp & trim
        if ($_ eq $lookingfor) {
            # the user has the desired #include/source command here... so all is well....  no error message needed
            return 1;
        }
    }
    close $fin;

    print "WARNING: ~/$file   already exists.  If you want to have local tailorings, insert this somewhere:\n\t$lookingfor\n";
    return 1;
}


sub _substitute {
    my ($file) = @_;

    warn "_substitute($file) not yet implemented\n";
}
