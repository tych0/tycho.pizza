---
title: Haggis, a static site generator
date: 2013-03-14
tags: haskell, haggis, hquery
---

Woah! tycho.ws looks totally different. Recently, I switched from using my old
custom blogging framework to a new static site generator that I wrote called
[haggis][1]. Both [haggis][2] and the source code for [this blog][3] are
available, so you can check them out and perhaps build your own haggis-based
blog if you want.

I did haggis as a static site generator mostly because I could. There's no
inherent reason for blogs to re-compute their pages on every request,
especially when there are very few comments on the blog (I think I've got
around 70 comments right now across all my posts). The comments support I
wrote for this blog is in fact totally separate from haggis -- the templates
have a form which does an AJAX post to a small script which basically dumps
the result in a database (after sanatizing it, of course :-). Haggis needs to
know nothing about the "dynamic" nature of the site. Then, the script simply
re-invokes haggis, which regenerates the whole blog.

Now, if all of the sudden I write a super popular post, my blog (probably?)
won't go down: the page is statically generated, so all the web server has to
do is read it off the disk and dump it on to the wire. No sessions, no
computation, no nothing. I'm using apache because I'm lazy and it's what I
know how to set up, but if I really wanted to, I could use some other more
performant web server for static files, thus increasing my capacity even more.

What happens, though, if lots of people start commenting all the time? Then I
spawn off N processes, which could confuse the web server if they're all
over-writing the files all the time. So, instead I check whether to
re-generate the blog once a minute, and only do it if necessary (i.e. if there
is a new comment). With this setup, hopefully I can handle a reasonably large
load with very few resources. And, of course, I can edit my posts in vim using
markdown, and manage the blog in git which were all requirements as well.

So, haggis probably performs much better than a GTFO-based (or any other
dynamic framework based) blog does, but why not just turn GTFO into a static
site generator? Well, the other reason for haggis is that I've been interested
in learning haskell for a while, and this was a perfect first project. Anyway,
haggis should be reasonably stable at this point, although there's still lots
of work left. Please report any bugs on the github page!

  [1]: http://hackage.haskell.org/package/haggis
  [2]: https://github.com/tych0/haggis
  [3]: https://github.com/tych0/tycho.ws
