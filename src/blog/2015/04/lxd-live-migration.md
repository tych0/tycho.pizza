---
title: Live Migration in LXD
date: 2015-04-06
tags: linux, lxd, criu, migration, containers
---

There has been a lot of interest on the various mailing lists as well as
internally at Canonical about the state of migration in LXD, so I thought
I'd write a bit about the current state of affairs.

Migration in LXD today passes the "Doom demo" test, i.e. it works well
enough to reproduce the [LXD announcement
demo](https://www.youtube.com/watch?v=a9T2gcnQg2k&t=1189) under certain
conditions, which I'll cover below. There is still a lot of ongoing work
to make CRIU (the underlying migration technology) work with all these
configurations, so support will eventually arrive for everything. For
now, though, you'll need to use the configuration I describe below.

First, I should note that things currently won't work on a systemd host.
Since systemd re-mounts the rootfs as `MS_SHARED`, lots of things
automatically become shared mounts, which confuses CRIU. There are
[several](http://lists.openvz.org/pipermail/criu/2015-April/019585.html)
[mailing
list](http://lists.openvz.org/pipermail/criu/2015-March/019299.html)
[threads](http://lists.openvz.org/pipermail/criu/2015-April/019652.html)
about ongoing work with respect to shared mounts in CRIU and I expect
something to be merged that will resolve the situation shortly, but for
now your host machine needs to be a non-systemd host (i.e. trusty or
utopic will work just fine, but not vivid).

You'll need to install the daily versions of liblxc and lxd from their
respective PPAs on each host:

    sudo apt-add-repository -y ppa:ubuntu-lxc/daily
    sudo apt-add-repository -y ppa:ubuntu-lxc/lxd-git-master
    sudo apt-get update
    sudo apt-get install lxd

Also, you'll need to uninstall `lxcfs` on both hosts:

    sudo apt-get remove lxcfs

`liblxc` currently doesn't support migrating the mount configuration that
lxcfs uses, although there is [some
work](http://lists.openvz.org/pipermail/criu/2015-March/019530.html) on
that as well. The overmounting issue has been fixed in lxcfs, so I expect
to land some patches in liblxc soon that will make lxcfs work.

Next, you'll want to set a password for your new lxd instance:

    lxc config set password foo

You need some images in `lxd`, which can be acquired easily enough by
lxd-images (of course, this only needs to be done on the source host of
the migration):

    lxd-images import lxc ubuntu trusty amd64 --alias ubuntu

which will then allow you to create a container to migrate:

    lxc init ubuntu migratee

Lastly, you'll also need to set a few configuration items in lxd. First,
the container needs to be privileged, although there is [yet
more](http://lists.openvz.org/pipermail/criu/2015-February/018934.html)
ongoing work to remove this restriction. There are also a few things that
CRIU does not support, so we need to set our container config to respect
those as well. You can do all of this using lxd's profiles mechanism,
that is:

    lxc config profile create migratable
    lxc config profile edit migratable

And paste the following content in instead of what's there:

    name: migratable
    config:
      raw.lxc: |
        lxc.console = none
        lxc.cgroup.devices.deny = c 5:1 rwm
        lxc.start.auto =
        lxc.start.auto = proc:mixed sys:mixed
      security.privileged: "true"
    devices: {}

And apply the profile to your container:

    lxc config profile apply migratee migratable

Finally, add both of your LXDs as non unix-socket remotes
([required](https://github.com/lxc/lxd/blob/master/lxc/copy.go#L79) for
now, but not forever):

    lxc remote add lxd thishost:8443   # don't use localhost here
    lxc remote add lxd2 otherhost:8443 # use a publicly addressable name

Profiles used by a particular container need to be present on both the
source of the migration and the sink, so we should copy the profile to
the sink as well:

    lxc config profile copy migratable lxd2:

And now, you're ready for the magic!

    lxc start migratee
    lxc move lxd:migratee lxd2:migratee

With luck, you'll have migrated the container to `lxd2`. Of course,
things don't always go right the first time. The full log file for the
migration attempts should be available in
`/var/log/lxd/migratee/migration_{dump|restore}_<timestamp>.log`, on the
respective host where the dump or restore took place. If you aren't
successful in migrating things (or parsing the dump/restore log), feel
free to mail
[`lxc-users`](https://lists.linuxcontainers.org/listinfo/lxc-users), and
I can help you debug what went wrong.

Happy hacking!
