---
title: A Tiling Window Manger
date: 2011-05-27
tags: wm, qtile, python
---

Ahoy! At the recommendation of one of my friends, I've recently begun
using a tiling window manger. Although he recommended [xmonad][1], I
decided to instead to go with a different project, [qtile][2]. I got
myself a [github][3] account, since that is the primary avenue for
qtile development. This means you can run the same WM code as I do
:-). (I also posted the code for the framework that powers this blog,
something I've been meaning to do for a while but have not gotten
around to.)

I wrote a widget for displaying the currently playing track from your
favorite player which implements [MPRIS][4], and I would be interested
in any feedback other qtile users have, so feel free to send me or
qtile-dev e-mail if you play with it! The widget can be found in both
my fork of qtile and in the main fork. It depends on python-dbus,
things like Ubuntu's update-manager do too, so it's probably installed
for most users. To use it, you can simply put
    
    widget.Mpris(objname='org.mpris.awesome_mpris_player')

in your qtile `config.py`. `objname` should be whatever the name of
your MPRIS player is. You can figure out what this is by running
`dbus-notify` and starting your player, and see what name it requests
when it issues `RequestName`. For example, Clementine's is
`org.mpris.clementine` (and is also the default).

Happy hacking!

 [1]: http://xmonad.org
 [2]: http://qtile.org
 [3]: http://github.com/tych0
 [4]: http://xmms2.org/wiki/MPRIS
