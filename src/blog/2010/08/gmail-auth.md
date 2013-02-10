---
title: Gmail Atom Feed Authentication
date: 2010-08-03
tags: gmail, python, free code
---

Perhaps the most complicated part of the application in my [recent
post][1] was the authentication with Gmail. Although my final method
boils down to only a few lines of python, Google describes
[several][2] [different][3] [ways][4] to authenticate (additionally,
putting the username and password directly in the URL). I didn't like
any of these options, as some seemed much too complicated for what I
wanted to do, some didn't work, and some were too insecure. However,
it turns out that the atom feed supports HTTP's [basic access
authentication][7]. In python, this is fairly easy to do:

    $ python
    >>> import urllib2, base64
    >>> username = "me@gmail.com"; password = "secret"
    >>> url = "https://mail.google.com/mail/feed/atom/"
    >>> req = urllib2.Request(url)
    >>> authstr = base64.encodestring("%s:%s" % (username, password))[:-1]
    >>> req.add_header("Authorization", "Basic " + authstr)
    >>> urllib2.urlopen(req).read()

Note that the above also works for Google apps users you just have to
stick "/a/example.com" in the appropriate spot in the URL. Hopefully
this will help out someone else who is hopelessly bashing Google's
servers with failed login attempts ;-)

 [1]: http://tycho.ws/blog/2010/08/gmail-notify
 [2]: http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html
 [3]: http://code.google.com/apis/accounts/docs/OAuthForInstalledApps.html
 [4]: http://code.google.com/apis/accounts/docs/OpenID.html
 [7]: http://en.wikipedia.org/wiki/Basic_access_authentication#Example
