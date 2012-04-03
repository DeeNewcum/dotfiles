## Yet another dotfile repository ##

    $  git clone https://github.com/DeeNewcum/dotfiles.git
    $  cd dotfiles
    $  ./setup.pl
    $  ls -l ~/.bashrc
    ~/.bashrc -> ~/dotfiles/.bashrc

    # Your dotfiles are safe.  Setup.pl won't overwrite anything.

## Overview ##

Run setup.pl, fix the file conflicts that it notes, run setup.pl...   repeat until it doesn't report any conflicts.

Setup.pl recognizes three different ways to incorporate ~/dotfiles/ settings into the working versions:

* **Symlink** — If you don't want any local-machine overrides. For example, ~/.bashrc can just be a symlink to ~/dotfiles/.bashrc

* **Source** — Some file types have the ability to 'source' another file.

* **Text substitution** — Setup.pl will read the text from *.subst files, and copy-n-paste it into the middle of the working version.
  
## Machine-specific overrides — via source ##

One way to have local machine-specific settings that override the global repository settings is to use the 'source' feature available in some file types.  For example, ~/.bashrc:

    # Pull in the global settings
    [ -f ~/dotfiles/.bashrc ] && source ~/dotfiles/.bashrc

    # Override the global settings for this specific machine
    export TERM=xtermc

Setup.pl [knows about each file type](https://github.com/DeeNewcum/dotfiles/blob/b3510c3a0bfedf2f33085a7eeacfa6586730b1f1/setup.pl#L124-131), and will suggest the appropriate 'source' line.

## Machine-specific overrides — via text substitution ##

For files that don't have 'source' capability, text substitution is available as a fallback.

For example, setup.pl will copy-n-paste the contents of ~/dotfiles/.ssh/config.subst into ~/.ssh/config:

    ######## MODIFICATIONS HERE WILL BE OVERWRITTEN BY CONTENTS OF: ~/dotfiles/.ssh/config.subst ########
    Host github.com
        User git
        IdentityFile ~/.ssh/github.priv
    ######## END SUBSTITUTION FROM: ~/dotfiles/.ssh/config.subst ########
    
    Host webstaging.work.com
        User my-username
    
    # ... a bunch of other private stuff that I don't want to make available on the public repository.

## Shared root ##

I manage boxes where several people have access to root.  To avoid stepping on each other other's toes, I have [set up root's ~/.bashrc](https://github.com/DeeNewcum/dotfiles/blob/master/.sudo_bashrc#L3-5) so that it loads a ~/.sudo_bashrc from the [original user's](http://paperlined.org/apps/host_sudo_su_boundaries/user_ids.html) home directory.

My own ~/.sudo_bashrc will pull in a variety of other .rc settings from the original home directory, including ~/.vimrc, ~/.inputrc, ~/.less, ~/.ackrc, and ~/.perltidyrc.

## My background ##

I use five unix boxes on a daily basis, so checking in my dotfiles is a must.

I often work in Ubuntu, RHEL, and Solaris.  And that's Solaris 9, on boxes I don't control so I can't install a modern GNU toolset, so there are various tricks here to coerce Solaris 9 to behave in similar ways to modern OS's.

## Similar projects ##

There are a [TON of other people](https://github.com/search?utf8=%E2%9C%93&q=dotfiles&repo=&langOverride=&start_value=1&type=Repositories&language=) who store their dotfiles on github.  Ones that stand out for me:

* [rtomayko](https://github.com/rtomayko/dotfiles)
* [aspiers](https://github.com/aspiers/shell-env)
* [claytron](https://github.com/claytron/dotfiles)
* [sjbach](https://github.com/sjbach/env)
* [mathiasbynens](https://github.com/mathiasbynens/dotfiles/)
* [yuzuemon](https://github.com/yuzuemon/dotfiles)
* [skwp](https://github.com/skwp/dotfiles)
* [ryanb](https://github.com/ryanb/dotfiles)
* [blueyed](https://github.com/blueyed/dotfiles)
* [phleet](https://github.com/phleet/dotfiles)
* [zan5hin](https://github.com/zan5hin/dotfiles)
* [nelstrom](https://github.com/nelstrom/dotfiles)
* [sontek](https://github.com/sontek/dotfiles)
* [sharad](https://github.com/sharad/rc) (uses m4 to customize files that have no 'source' capability)

## License ##

Unless otherwise noted, files here are available under the [CC0 1.0](http://creativecommons.org/publicdomain/zero/1.0/) license.

Some files (particularly ones authored by other folks) may have their own licensing information at the top of the file.  Those notices supercede this one.
