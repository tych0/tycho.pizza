---
title: CFFI-based Qtile!
date: 2014-06-21
tags: qtile, python
---

For the past while I've been working on a reimplementation of [xpyb][1] in
[cffi][2]. There are several reasons to want to do this:

#. xpyb has at least [one more][3] memory leak (but probably others)
#. The xpyb upstream is inactive, and there is no sign of a python 3 port
#. It would be uber cool to be able to run qtile in pypy.

Using cffi soves 2 and 3 pretty easily, and I've made sure that xcffib's test
suite runs through valgrind with no definite leaks, hopefully mitigating 1.
However, even if we have xcffib, there is still a lot of work that needed to
happen to make qtile run on top of it. I'm writing this post to announce that
some of that work is done, and late last night I was able to boot qtile running
on top of xffib! There are still lots of bugs, and lots of testing needs to
be done, but we're most of the way there I think, and running qtile on python3
and pypy without memory leaks is no longer a pipe dream :-).

To install, you'll need:

#. `sudo apt-get install xcb-proto libpango1.0-dev libcairo2-dev` (or whatever
   the equivalent packages are on your distro)
#. Follow the [installation instructions][4] for xcffib.
#. Install the `xcffib` branch of [tych0/cairocffi][5]
#. Install the `cffi` branch of [tych0/qtile][6]

I have not tried to test qtile on python 3 yet, so there may be some work that
needs to be done to successfully run things on python 3. However, both xcffib
and cairocffi run their test suites on python 3, and so the only work that
needs to be done is probably in qtile, if any. pypy is another story however,
as xcffib does not currently pass its test suite on pypy. I plan to fix that at
some point, but I'd like to get qtile running completely before that happens.

Finally, there are some bugs that manifest with qtile right now:

#. The systray doesn't work. This is probably due to a bug in the way xcffib
   unpacks ClientMessage events.
#. Most of the text-based widgets don't work. This is probably due to a bug in
   the pangocffi binding I wrote for qtile. I thing it is just an
   incompleteness, and I will try and fix it either today or tomorrow. Basic
   text widgets like the clock or the volume widget work just fine.
#. Lots of other things are probably broken :-). Bug reports welcome.

Happy hacking!

[1]: https://pypi.python.org/pypi/xpyb/1.3.1
[2]: https://cffi.readthedocs.org/en/release-0.8/
[3]: https://github.com/qtile/qtile/issues/395
[4]: https://github.com/tych0/xcffib/blob/master/.travis.yml#L17
[5]: https://github.com/tych0/cairocffi/tree/xcffib
[6]: https://github.com/tych0/qtile/tree/cffi
