## Yet another dotfile repository ##

    $  git clone https://github.com/DeeNewcum/dotfiles.git
    $  dotfiles/setup.pl
    $  ls -l .bashrc
    ~/.bashrc -> ~/dotfiles/.bashrc
    
    # Your dotfiles are safe.  Setup.pl won't overwrite anything.

## My background ##

I use 5 unix boxes on a daily basis, so checking in my dotfiles is a must.

I often work in Ubuntu, RHEL, and Solaris.  That's Solaris 9, on boxes I don't control so can't install a modern GNU toolset, so there are various tricks in here to try to coerce Solaris 9 to behave in similar ways to more modern OS's.

## General structure ##

<tt>setup.pl</tt> is designed to be run repeatedly.  Run <tt>setup.pl</tt>, manually fix the problems that it notes, run <tt>setup.pl</tt>, ... repeat until <tt>setup.pl</tt> doesn't report any issues.

<tt>setup.pl</tt> recognizes three different ways that the settings from ~/dotfiles/ directory can be incorporated into the working version:

* **Symlink** — The easiest way is just to symlink, for example, ~/.bashrc → ~/dotfiles/.bashrc
* **Source** — Some specific files have the ability to 'source' or '#include' another file.  For example, ~/.bashrc could include the line <tt>[ -f ~/dotfiles/.bashrc ] && source ~/dotfiles/.bashrc</tt>
* **Text substitution** — <tt>setup.pl</tt> can take the text that's in ~/dotfiles/.gitconfig.subst, and do text-substitution to insert the text into a specific place within ~/.gitconfig.
 
## Machine-specific overrides, via source ##

In some cases, I want to have local settings, specific to a machine, that override the repository settings.

For files that allow for 'source' or '#include' functionality, this is possible.  For example, ~/.bashrc can be a real file (instead of a symlink), and I can change settings before and after the line that sources ~/dotfiles/.bashrc.

<tt>setup.pl</tt> knows about each file type, and will suggest the appropriate 'source'/'#include' line, whenever it notices an existing local file that conflicts.

## Machine-specific overrides, via text substitution ##

(coming soon — this is needed for ~/.gitconfig and ~/.ssh/config, which are unable to source files)

## Shared root ##

I manage boxes where several people have access to root.  To avoid stepping on each other other's toes, I have [set up root's ~/.bashrc](https://github.com/DeeNewcum/dotfiles/blob/master/.sudo_bashrc#L3-5) so that it loads a ~/.sudo_bashrc from the [original user's](http://paperlined.org/apps/host_sudo_su_boundaries/user_ids.html) home directory.

My own ~/.sudo_bashrc will pull in a variety of other .rc settings from the original home directory, including ~/.vimrc, ~/.inputrc, ~/.less, ~/.ackrc, and ~/.perltidyrc.

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
