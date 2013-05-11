---
title: Qtile 0.6 released!
date: 2013-05-11
tags: qtile, python, free code
---

I have just tagged and released qtile 0.6! This release comes exactly 6 months
after our last release (not intentionally, it just happened to work out that
way). You can check out the [full release notes][1] for a list of most of the
changes.

I thought I'd discuss a bit about the breaking config changes we made. A few of
them were long standing TODOs in the code, but the major one (and the one that
motivated cleaning up all the rest) was creating a new config module where all
of the objects used in configuration live. The primary motivation for this
change was to remove a lot of crazy hacks we had in the test system to get
around circular imports, since the configuration objects and main manager were
all in the same file. However, it also makes sense from a code organization
standpoint, because manager.py was getting huge. I think user impact will be
minimal, because configs can be updated with a simple regex. That said, I will
only be updating the Ubuntu 13.04 packages, so as not to break configs for
existing users on older packages with a simple dselect-upgrade.

As always, questions or comments are welcome on [qtile-dev][2]!

  [1]: http://docs.qtile.org/en/latest/releases/0.6.html
  [2]: https://groups.google.com/forum/?fromgroups#!forum/qtile-dev
