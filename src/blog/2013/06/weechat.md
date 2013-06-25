---
title: Weechat with an alternative timezone
date: 2013-06-25
tags: weechat, irc, utilities
---

A common usecase (and one I was interested in) for weechat is to run it on a
VPS in screen, so that you don't lose your IRC session when you turn off your
computer. This all works well and good, except that all the timestamps for the
messages will be in the server's local time, instead of your time. If you dig
through the code, though, you find that weechat uses the `strftime()` call,
which respects the TZ environment variable. So, if your server is in a
different time zone than you are, you can start weechat by:

    TZ='US/Central' weechat-curses

and all the timestamps it displays will be in `US/Central` time.
