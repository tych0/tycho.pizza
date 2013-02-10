---
title: Viridian/Ampache local control
date: 2012-01-23
tags: free code, python, ampache
---

Recently at work I've been using [Viridan][1] to listen to music at work. It
has its warts, but generally works pretty well. There's even an XMLRPC server
built in, so you can control it remotely. However, there's not a huge number of
clients out there, so I wrote my own little script so that I could start and
stop it from a Qtile keybinding, and I thought I'd [put it up][2] here for anyone
else who is interested. Here's an example session:

    smitten:~$ ./vif.py 
    ./vif.py [rpc_call(s)]
       availible methods are:
         get_current_song
         get_state
         get_volume
         next
         play_pause
         prev
         set_volume
         volume_down
         volume_up
    smitten:~$ ./vif.py get_current_song
    {'artist_name': 'Meshuggah','song_title': 'Stengah', ...}
    smitten:~$ ./vif.py next
    True

Hopefully someone else finds it useful :-)

 [1]: http://www.daveeddy.com/projects/launchpad/viridian-ampache-front-end/
 [2]: blog/2012/01/vif.py
