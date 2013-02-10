title=Spam on my blog!
tags=spam, meta
date=2010-06-28
%%%%%%%%%

In an interesting twist, you may have noticed that my blog received
some spam posts the other day. This seems pretty amazing to me, since
I wrote this page myself, and there is exactly one deployment of it
(which is here). I can see writing spam bots for popular frameworks
like Wordpress, Joomla, Drupal, etc. but this isn't exactly a popular
framework ;-). The fact that I got spammed leads me to believe that
spammers are applying some sort of machine learning techniques to
figure out what looks like a comment form, and what doesn't. It never
ceases to amaze me the lengths people will go to in order to spam.

How did I remove it? Well naturally I've been too lazy to code an
admin interface (and why would I? I write the blog posts in vi). So, I
had to fire up the sqlite driver (I use a database to store the
comments) and manually delete them myself. If this keeps occurring,
I'll probably try to build in some sort of simple spam filtering AI or
at least an interface which makes it easy to delete the spam.

Either way, I'm flattered that people think my website is popular
enough that they *have* to post their spam links on it ;-)
