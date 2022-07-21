These are similar to, but not literally the same as:

* [Brew Formulas](https://github.com/mxcl/homebrew/wiki/Formula-Cookbook) ([examples](https://github.com/mxcl/homebrew/tree/master/Library/Formula/))
* [Zero Install](http://0install.net/) ([examples](http://roscidus.com/0mirror/))
* [ebuild](http://en.wikipedia.org/wiki/Ebuild) ([examples](http://gentoo-portage.com/Newest))
* [PKGBUILD](http://en.wikipedia.org/wiki/Arch_Linux#Arch_User_Repository) ([examples](http://aur.archlinux.org/packages.php) — click on the " :: PKGBUILD" link)
* [SlackBuild scripts](http://www.slackwiki.com/SlackBuild_Scripts) ([examples](http://www.slackbuilds.org/repository/13.37/development/) — see "individual files")
* it may even be possible to install dependencies via the native package manager, by using the compatibility layer [PackageKit](http://www.packagekit.org/pk-users.html)

These scripts will download and compile various things from source for me, and configure them the way I want.

Some of them ultimately dump their binaries into ~/apps/stow/.

These scripts may eventually become more like proper ebuild/pkgbuild scripts, but for now, they're fairly immature and hard-coded.
