title=Google Voice ncurses interface
date=2011-06-14
tags=python, ncurses, sms
%%%%%%%%%%

For a while I have been using a Google Voice number as my primary
texting number since it doesn't cost any money and has the additional
benefit that when I'm at a computer, I can type text messages on a
regular keyboard instead of on my tiny phone keyboard. This is all
well and good, except I don't particularly care for the web interface;
not because it's bad, but simply because it requires you to have a web
browser open.

To solve this, I wrote an ncurses based "chat" client, [gvchat][1].
It provides and instant messaging interface for the most recent text
message your GV account has received. When someone new texts you, it
seamlessly switches to that new thread. At this point there is no way
to initiate new texts, but I plan on growing the feature set in the
coming months. However, for now it fits my needs so I thought I'd put
it up for other people in the same boat.

Additionally, the client has a class 'Chat', which implements a crude
ncurses based chat interface. As this improves, my hope is to add an
XMPP backend for it as well. Any ncurses tips and tricks (or pointers
to libraries which already have this functionality and are built on
top of ncurses) are much appreciated!!

  [1]: https://github.com/tych0/gvchat
