title=Qtile packages for Ubuntu 12.10 (Quantal Quetzal)
date=2012-10-19
tags=free code, python, qtile, ppa, ubuntu
%%%%%%%%%%

Ahoy! I have put up new packages for qtile for 12.10, so I thought I'd
write a bit about what's actually in the packages. First, they're
available via the standard:

    sudo apt-add-repository ppa:tycho-s/ppa
    sudo apt-get update
    sudo apt-get install qtile

A few things to note about these packages. First: they now install a
qtile.desktop file, so any compliant freedesktop.org login manager
should see qtile as a login option. Note that this just invokes qtile
directly with no arguments, so you'll have to put your configs in the
standard location. If you want to run a custom `.xsession`, you'll
still need to set that up yourself.

Second, these packages no longer depend on xpyb-ng, but depend on xpyb
(1.3.1) directly. I did this for a few reasons. I've had
several users report that 1.3.1 works directly for them (i.e. xpyb-ng
is not actually required to run qtile). If there is no problem with
using the stock implementation, I felt like we should switch to that.
Naturally, if problems come up and we need to move back to our fork,
I'm happy to rebuild, however, I think that's unlikely.

Third, which hash are these packages based on? They're based on
[87dc6924cb][2], which is on the development branch. I've been running
this code both at home and at work for several months now, as well as
several other people. While there are still several bugs (patches
welcome!), I feel that it's much more stable and user friendly than
the master branch.

Fourth, based on some statistics that Launchpad provides, it looks
like there were about 100 installs of the Ubuntu PPA. One or two of
those were probably my test VMs, but that means there were a fair
number of other people who checked qtile out. Very cool!

Feel free to e-mail me or [qtile-dev][1] with any feedback!
(Unfortunately, I've been inadvertently banned from qtile-dev somehow.
Still waiting on a resolution to that, so if you find a bug with the
packages, go ahead and just file it on the github tracker and I'll fix
it ASAP.)

 [1]: http://groups.google.com/group/qtile-dev
 [2]: https://github.com/qtile/qtile/commit/87dc6924cbeab92f2b48b05623e0de53efd68400
