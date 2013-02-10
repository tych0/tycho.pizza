---
title: Installing Qtile on Ubuntu 11.10 (Oneiric Ocelot)
date: 2012-01-26
tags: free code, python, qtile
---

Recently, there has been some discussion on [qtile-dev][1] about
installing the latest and greatest version of qtile. Unfortunately,
the install process has historically been a journey into dependency
hell, since distributions didn't have the latest versions of some
libraries required by qtile. The good news is that this has mostly
been fixed (although very few documents anywhere state this), so it's
hard to know what to install by hand and what you can use packages
for.

To complicate matters more, there are several versions of xpyb
floating around, none of which have working build systems! If you knew
enough about pkg-config and weren't afraid of manually installing
files, you could get everything to work, but it did bar the "normal
user" from installing qtile. Hopefully this blog post will clarify a
few things.

First, what dependencies do you need to install? Contrary to what the
docs say, in 11.10 (and presumably later versions of Ubuntu), you
don't need to build your own cairo or xcb. You can simply:

    sudo apt-get install xcb-proto libxcb1-dev python-xcbgen
    libcairo2-dev

You will have to build three things by hand: `xpyb`, `py2cairo`, and
`qtile` itself. The other day I sat down and fixed the build system
for `xpyb`, so you should be able to just:
    
    git clone git://github.com/tych0/xpyb-ng.git
    cd xpyb-ng
    sudo python setup.py install

After that, you'll need to install `py2cairo`. The `waf` based build
doesn't appear to detect xpyb correctly, so you'll need to go the
autoconf route. Even with autoconf, the build system is slightly
broken, so you'll need to be explicit about what directories to look
in for `xpyb.h`. If you used the above build of xpyb, you can:
    
    git clone git://git.cairographics.org/git/py2cairo
    cd py2cairo
    CFLAGS=-I/usr/local/include/python2.7/xpyb ./configure
    sudo make install

Then, you can clone your favorite qtile repo and everything should
Just Work! If you want to clone my copy of qtile (which includes
several bug fixes and enhancements):

    git clone https://github.com/tych0/qtile
    cd qtile
    sudo python setup.py install

If you have any questions or problems, feel free to mail qtile-dev or
me directly. I am going to try and package qtile and put it in a PPA,
but I doubt I will get to that for another few weeks. This should help
anyone who is interested enough to build it in the meantime, though!

 [1]: http://groups.google.com/group/qtile-dev
