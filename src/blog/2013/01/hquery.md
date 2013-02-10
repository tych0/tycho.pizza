---
title: Hquery, an HTML5 tree rewriting tool
date: 2013-01-29
tags: free code, haskell, html
---

Recently I began rewriting the framework that powers this blog
([gtfo][1]) in haskell. Among other things, I needed a good tree
rewriting utility for processing templates and generating content.
I've been using [Lift][2] at work for a while now, so I built
hquery, which is basically an implementation of Lift's [CSS
Selectors][4] over [xmlhtml][5] trees. You can see some examples of
the kind of transformations it allows in [hquery's readme][6].
Additionally, it is available from [hackage][7] via `cabal install
hquery`.

Feedback is welcome, as this is my first haskell API. Bug reports and
patches are of course welcome too :-)

  [1]: https://github.com/tych0/gtfo
  [2]: http://liftweb.net/
  [4]: http://simply.liftweb.net/index-7.10.html
  [5]: http://hackage.haskell.org/package/xmlhtml
  [6]: https://github.com/tych0/hquery#examples
  [7]: http://hackage.haskell.org/package/hquery
