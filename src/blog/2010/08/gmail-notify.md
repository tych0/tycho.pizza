---
title: Gmail, Conky, and libnotify
date: 2010-08-01
tags: gmail, conky, libnotify, python, free code
---

Several years ago I discovered a fantastic system monitor named
[conky][1]. Over the years I've been tweaking my .conkyrc and it has
really evolved into a little command center all on it's own. However,
I read my e-mail through a mutt, and thus to check it I have to open
mutt and look and see if I have any new mail. This is often obnoxious,
because I'll either forget to check and miss something until later, or
I'll check a lot and not get any e-mail. Today it occurred to me "hey,
computers are good at repetitive tasks!", so I decided to
automatically check my e-mail and render the results in conky. I also
have heard lots of noise about libnotify, and how wonderful it is, so
I decided to use that as well. The result is a script which checks a
user's Gmail (using a password stored in a keyring), updates conky,
and shows a libnotify notification if necessary. It also supports
querying of arbitrary Gmail labels, allowing you to display unread
counts for other e-mail addresses you might possibly have mapped to
your Gmail account.

You can get your own [copy][2] to play around with if you like. It's
fairly well documented, but I'll answer any questions anyone has. The
dependencies (at least on Ubuntu) are `python-notify python-keyring`
and your favorite of: `python-keyring-gnome` or
`python-keyring-kwallet`. 

I've released it under a [beerware][3] style license, in hopes that
someone, somewhere, might find it useful. Feedback is appreciated!

 [1]: http://conky.sourceforge.net
 [2]: http://files.tycho.ws/code/gmail_notifier/gmail_unread.py
 [3]: http://en.wikipedia.org/wiki/Beerware
