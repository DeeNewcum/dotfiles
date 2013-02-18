## Yet another dotfile repository ##

    $  git clone https://github.com/DeeNewcum/dotfiles.git
    $  cd dotfiles
    $  ./deedot
    $  ls -l ~/.bashrc
    ~/.bashrc -> ~/dotfiles/.bashrc

    # Your dotfiles are safe.  DeeDot won't overwrite anything.

This is my config file repo.  There are [many like it](https://www.google.com/search?channel=fs&q=site%3Agithub.com+dotfiles&ie=utf-8&oe=utf-8), but this one is mine.

## Dotfile repos generally

Before we get into the details of my dotfiles, I'd like to point out that MANY people have done dotfiles, and there are some good references out there:

* [dotfiles.github.com](http://dotfiles.github.com/)
* [dotfiles.org](http://dotfiles.org/)
* [dotshare.it](http://dotshare.it/)
* good articles: [(1)](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/)
* popular dotfile repos:  [mathias bynens](https://github.com/mathiasbynens/dotfiles)

## [DeeDot](https://github.com/DeeNewcum/deedot) ##

DeeDot is the tool that installs symlinks from ~/dotfiles/ to the live version of each file.  The tool is maintained as a [separate project](https://github.com/DeeNewcum/deedot), and there's a good amount of documentation over there.

## Shared root feature ##

On some of my boxes, several different people have root access.  To avoid stepping on each other other's toes, I [set up root's ~/.bashrc](https://github.com/DeeNewcum/dotfiles/blob/master/.sudo_bashrc#L1-5) so that it loads a ~/.sudo_bashrc from the original user's home directory, so that each user can have personalized settings despite using a shared account.

[My personal ~/.sudo_bashrc](https://github.com/DeeNewcum/dotfiles/blob/master/.sudo_bashrc) has code that pulls in other .rc settings from the original home directory, including ~/.vimrc, ~/.inputrc, ~/.less, ~/.ackrc, and ~/.perltidyrc.

## My philosophy ##

I sometimes work on older Un*xes, so I prefer to use scripting languages that are widely available, and use scripts that have a bare-minimum of dependencies.  Generally, this means older versions of Perl (using minimal extra modules) and Bash/sh scripts.

I believe in [using URLs whenever possible](https://github.com/DeeNewcum/dotfiles/wiki/URL-centric).

I work on ~5 different machines on a daily basis, so checking in dotfiles is very valuable to me.

## Tools I work with ##

I frequently do work on Ubuntu, RHEL, and Solaris v9 and v10.

My personal preferences are: Vim, Perl, Bash, and Screen.  (I'm going to try out tmux and zsh when I get a chance)

## TODO ##

There are several other large pieces of live-config-files that aren't checked in yet, that I would like to.  These may take some work to figure out:

* my [Firefox profile](https://github.com/DeeNewcum/dotfiles/issues/15)
  * **particularly my Greasemonkey scripts**
* my [Thunderbird profile](https://github.com/DeeNewcum/dotfiles/issues/15#issuecomment-6276610), particularly the message filters
* my [Android Tasker](http://lifehacker.com/5599116/how-to-turn-your-android-phone-into-a-fully+automated-superphone) scripts
* my [Tropo.com](http://www.tropo.com/) scripts
  * Despite the fact that Tropo.com's main use-case is large-scale applications, it "[is always free for developer use, it's not a limited time offer](https://www.tropo.com/docs/scripting/faq.htm)".  This makes it very handy for building personal utilities. (eg. the [Google Voice enhancement that makes it possible for Google Voice to forward to a number that requires an extension](http://blog.tropo.com/2011/05/13/extending-googevoice-with-tropo/))

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

[Vim-specific ones](https://www.google.com/search?hl=en&q=site%3Agithub.com+vim+configuration+OR+vimrc+OR+settings+OR+plugins):

* [**janus** by carlhuda](https://github.com/carlhuda/janus/) — the most well-known...  it has been compared to the venerable [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/), in terms of providing a good starting base, allowing you to avoid a lot of work just to get a modern environment working quickly
* [amix](https://github.com/amix/vimrc)
* [krisleech](https://github.com/krisleech/vimfiles)
* [nvie](https://github.com/nvie/vimrc)
* [trinitum](https://github.com/trinitum/vimrc)

## License ##

Unless otherwise noted, files here are available under the [CC0 1.0](http://creativecommons.org/publicdomain/zero/1.0/) license.  (ie. public domain)

Some files are authored by other folks and have author/licensing information at the top that supersedes this license.
