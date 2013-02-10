---
title: Mutt Sidebar Configuration
date: 2011-10-26
tags: ncurses, mutt
---

I am a [mutt][1] user (in fact, I'm a [mutt-sidebar][3] user). That
means several things, one of which is that I spend a nonzero amount of
time configuring my e-mail client to behave as I want it to. I am also
a [vim][2] user, and in the spirit of loving vim, I set out on an
adventure to make everything look and feel like vim. A natural thing
to want to do is be able to navigate the sidebar (i.e. the folder
list) with `j` and `k` keys as one does in vim. Reasonable attempts at
this fail for various reasons, and I hope this post will explain why
and also how to do what you want.

First, a natural thing to want to do is to bind sidebar navigation to
`<ctrl>+j` and `<ctrl>+k`, since the `<ctrl>` binding indicates
somehow that the navigation is "slightly different", and therefore is a
good mnemonic for a "slightly different" kind of up and down movement.
To do this, you could put something like:
    
    bind index,pager \ck sidebar-prev
    bind index,pager \cj sidebar-next

at the end of your `~/.muttrc`. However, this has an unexpected
result: moving up and down in the menu works just fine, but now
pressing `<return>` also moves you down in the sidebar, instead of
opening the highlighted message (its default) or whatever else you had
it set to.

The problem is that `<ctrl>+j` and `<return>` are actually the same
character. That is, when you press `<ctrl>+j` the terminal interprets
it and sends an ASCII 10 (the `LF` character), which is the same thing
that `<return>` sends. In fact `<ctrl>+*` (where `*` is any character
a-z) is bound to some control code (it's just that most of them are
unused in modern applications, e.g. `<ctrl>+i` is an alias for tab).
Unfortunately that means we can't bind `<ctrl>+j` and `<return>` to
different things in mutt, since they're actually the same character.

So what's the workaround? Well, I decided that `<alt>` is just as
reasonable as `<ctrl>`. Running `:exec what-key` told me that `\252`
(i.e. octal 252) is `<alt>+j`, so I can add the following lines to
`~/.muttrc`:
    
    bind index,pager \253 sidebar-prev
    bind index,pager \252 sidebar-next

but it didn't work! Mutt Well, it might work for some people, depending on
their terminal configurations. According to the [Rute User's tutorial
and Exposition][4]:
  
> The alt modifier (i.e. Alt-?) is in fact a short way of pressing and
> releasing Esc before entering the key combination; hence Esc then f
> is the same as Alt-f--UNIX is different from other operating systems
> in this use of Esc.

So what's the issue? Well, some terminals do this by default, and some
don't. In xterm, the default is not to convert `<alt>` characters into
the escape sequences mutt expects. However, by putting

    xterm*metaSendsEscape: true

in your `~/.Xresources` and running `xrdb ~/.Xresources` and
restarting xterm, it /will/ interpret `<alt>` keypresses correctly,
and your `<alt>+j` keybindings will work.

[1]: http://www.mutt.org
[2]: http://www.vim.org
[3]: http://www.lunar-linux.org/index.php?option=com_content&task=view&id=44
[4]: http://rute.2038bug.com/node5.html.gz#SECTION00560000000000000000
