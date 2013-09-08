---
title: Manage passwords without state
date: 2013-09-06
tags: password, security, free code, python
---

A few years ago I had a problem: I had a bunch of accounts that I accessed once
a year when tax time came around, and I kept forgetting the passwords. Often
I'd try a few before locking myself out, and then I'd have to spend an hour on
the phone with customer service getting my account unlocked, which meant if I
was doing my taxes on the last weekend possible, I wouldn't be able to complete
them until the next business day. The obvious solution to this problem is to
store the passwords in some kind of password manager -- lots of them exist for
all kinds of platforms: phone, computer, browser, etc.

The problem with password manager is that they typically require some kind of
state file. They store the mapping between site and cleartext password in some
file, and then they decrypt it with some secret from you when you want to
access it. Thus, you have to 1. trust the person who is doing the encrypting
and decrypting that they are doing it correctly so that when your laptop gets
stolen your passwords aren't leaked, and 2. you have to have _access_ to the
machine that the passwords are stored on when you want to use them. If you've
left your laptop at home or you forgot to back up your password file when you
got a new computer, you're SOL.

What's the solution? A password manager without state, of course! Since we're
assuming the user can remember at least one pretty good password, we can use
that as our "state", so we end up with the algorithm as follows:

    hash = sha512(user_secret + "example.org")
    base64encode(hash)[:10]

Here, we're using the domain to salt the user secret so the generated passwords
are different for each site. `sha512` provides randomness, although we are only
using the first 60 bits of the output here (10 base64 characters, each
character encodes six bits of entropy), there are significantly more bits of
entropy here than in your typical English character, making it a much stronger
password. Further, the algorithm is very simple, and you could re-implement it
on any computer that has your favorite programming language environment
available. Thus, you can use it in a pinch, since all you need to remember are
the algorithm and your `user_secret`. I've [published][1] a python script that
implements this mechanism, so you don't even have to remember the algorithm

  [1]: https://github.com/tych0/password
