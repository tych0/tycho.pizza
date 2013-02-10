---
title: Rendering your current Clementine track in Conky
date: 2010-10-23
tags: conky, clementine, script
---

I've been using [Clementine][1] as a replacement for Amarok for the last
few months (it's fairly feature complete, and you don't have to have
all of KDE loaded into memory, so it is actually fast). As I also use
Conky, it's only natural to want the currently playing track to be
rendered in Conky. This isn't too hard, since Clementine exposes this
information via dbus. You can see code to do this below:

    #!/bin/bash
    TRACK=`qdbus org.mpris.clementine /TrackList \
    org.freedesktop.MediaPlayer.GetCurrentTrack`
    qdbus org.mpris.clementine /TrackList \
    org.freedesktop.MediaPlayer.GetMetadata $TRACK \
    | sort -r | egrep "^(title:|artist:)" | sed -e "s/^.*: //g" \
    | sed -e ':a;N;$!ba;s/\n/ - /g' | head -c 36

I put this in a script called `nowplaying`, and when run, it gives me
output in `Track name - Artist` format. I cut off the output after 36
characters because that's about the size of my Conky window, and songs
with longer names will cause Conky to automatically resize its window,
which I think is distracting. You can chop the last bit off if you
don't want this. Also, although I generally prefer `Artist - Track
Name` notation, I can usually tell who the artist is, so I listed the
track name first in case the combination was over my 36 character
limit. You can switch it back to `Artist - Track name` by removing the
`-r` flag from the sort command above.

Now, to get this information into Conky, add a line to your
`~/.conkyrc` that looks something like this:

    Now playing: ${execi 10 ~/config/bin/nowplaying}

Every 10 seconds, this will ping Clementine and ask it what is
playing. If nothing is playing (or clementine is not running), this
will simply render the empty string.

 [1]: http://www.clementine-player.org/
