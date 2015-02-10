---
title: setproctitle() in Linux
date: 2015-02-09
tags: linux, lxd, C
---

While working on LXD, one of the things I occasionally do is submit patches to
LXC (e.g. the migration work or other things). In particular, the name of the
LXC monitor process (the process that's the parent of init) is `fork()ed` in
the C API call, so whatever the name of the binary that ran the API call (in
our case, LXD) is the name of the parent. This could be slightly confusing
(especially in the case where LXD dies but a process that looks like it is
named LXD lives on). Should be easy enough to fix, right? Lots of \*nixes seem
to have a `setproctitle()` function to correct this, so we'll just call that!

And lo, there is `prctl()` which has a `PR_SET_NAME` mode that we can use.
Done! Except from one small caveat from the man page:

> The name can be up to 16 bytes long, and should be null-terminated if it
> contains fewer bytes.

Yes, you read that, 16 bytes; not useful for a lot of process names,
especially something which would be ideal for LXC:

    [lxc monitor] /var/lib/lxc container-name

Ok, so how hard can it be to write our own? If you look around on the
internet, a lot of people suggest something like `strcpy(argv[0],
"my-proc-name")`. That works, but what happens if your process name is longer
than the original? You smash the stack! Try `cat /proc/<pid>/environ` on the
program below:

    #include <string.h>
    #include <stdio.h>

    int main(int argc, char* argv[]) {
        char buf[1024];
        memset(buf, '0', sizeof(buf));
        buf[1023] = 0;
        strncpy(argv[0], buf, sizeof(buf));
        sleep(10000);
        return 0;
    }

If your process name is longer than the original environment, you overwrite
something else potentially more useful, which could cause all sorts of
nastiness, especially as something that runs as root.

The thing is, the environment isn't necessarily all that useful; it doesn't
indicate the current environment, just the initial environment. So we could
use that space for the process name, as long as the kernel knew the
environment wasn't valid any more. `prctl()` to the rescue again, we can pass
it `PR_SET_MM` and `PR_SET_MM_ENV_{START|END}` to update these locations.

Problem solved! Except that we want to do this from `liblxc.so`, which has no
concept of argv. `prctl()` has no `PR_GET_MM` calls, so we can't just go the
other way with it. We could invent some ugly API where you have to pass it in,
but that would require users to either set their argv pointers up front, or
carry it around until they needed it, or something similarly ugly. Instead, we
steal an idea from the CRIU codebase: we look in `/proc/<pid>/stat`. This file
has (in columns 48-51, if your kernel is new enough) exactly the arguments you
want from `PR_GET_MM_*`! Thus, we can use this file to find out inside of
liblxc where is safe to put the new proctitle.

Putting it all together, [liblxc now has an implementation of
`setproctitle()`][1] that will overwrite your initial environment (but is
careful not to overwrite anything else), which can be used to set process
titles longer than 16 bytes. Enjoy!

[1]: https://github.com/lxc/lxc/blob/master/src/lxc/utils.c#L1572
