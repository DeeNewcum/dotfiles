## Yet another dotfile repository ##

    $  git clone https://github.com/DeeNewcum/dotfiles.git
    $  cd dotfiles
    $  ./deedot
    $  ls -l ~/.bashrc
    ~/.bashrc -> ~/dotfiles/.bashrc

    # Your dotfiles are safe.  DeeDot won't overwrite anything.

This is my personal dotfile repo.  There are [many like it](https://github.com/search?utf8=%E2%9C%93&q=dotfiles&repo=&langOverride=&start_value=1&type=Repositories&language=), but this one is mine.

## [DeeDot](https://github.com/DeeNewcum/deedot) ##

DeeDot is a [separate project](https://github.com/DeeNewcum/deedot) I maintain.  It's a tool that installs/maintains symlinks for people's dotfile repostories.  It's well-documented [over there](https://github.com/DeeNewcum/deedot).

## Shared root ##

I manage boxes where several people have access to root.  To avoid stepping on each other other's toes, I have [set up root's ~/.bashrc](https://github.com/DeeNewcum/dotfiles/blob/master/.sudo_bashrc#L3-5) so that it loads a ~/.sudo_bashrc from the original user's home directory. 

My own ~/.sudo_bashrc will pull in a variety of other .rc settings from the original home directory, including ~/.vimrc, ~/.inputrc, ~/.less, ~/.ackrc, and ~/.perltidyrc.

## My take on things ##

I sometimes work on older Un*x variants (eg. Solaris 9), so I prefer to use tools that have a bare-minimum of dependencies.  Generally, this means older versions of Perl (using minimal non-core modules) and Bash scripts.  Sometimes it means a non-GNU toolset, or KSH-88 scripts.

I work on ~5 different machines on a daily basis, and ~10 on a monthly basis.

## My environment ##

I frequently work in Ubuntu, RHEL, and Solaris 9.

My personal preferences are: Vim or Vi, Perl, Bash, and Screen.  (I want to try out tmux and zsh soon)

## TODO ##

There are several other large pieces of live-config-files that aren't checked in yet, that I would like to.  These may take some work to figure out:

* my [Firefox profile](https://github.com/DeeNewcum/dotfiles/issues/15), particularly the Greasemonkey scripts
* my Thunderbird message filters
* my Android Tasker "programs"
* my Tropo.com scripts

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
