---
title: Mounting your home directory in LXD
date: 2016-12-07
tags: containers, lxd
---

As of LXD stable 2.0.8 and feature release 2.6, LXD has support for various UID
and GID map related manipulaions. A common question is: "How do I bind-mount my
home directory into a container?" and before the answer was "well, it's
complicated but you can do it; it's slightly less complicated if you do it in
privleged containers". However, with this feature, now you can do it very
easily in unprivileged containers.

First, find out your uid on the host:

    $ id
    uid=1000(tycho) gid=1000(tycho) groups=1000(tycho),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),112(lpadmin),124(sambashare),129(libvirtd),149(lxd),150(sbuild)

On standard Ubuntu hosts, the uid of the first user is 1000. Now, we need to
allow LXD to remap this id; you'll need an additional entry for root
to do this:

    $ echo 'root:1000:1' | sudo tee -a /etc/subuid /etc/subgid

Now, create a container, and set the idmap up to map both uid and gid 1000 to
uid and gid 1000 inside the container.

    $ lxc init ubuntu-daily:z zesty
    Creating zesty
    $ lxc config set zesty raw.idmap 'both 1000 1000'

Finally, set up your home directory to be mounted in the container:

    $ lxc config device add zesty homedir disk source=/home/tycho path=/home/ubuntu

And leave an insightful message for users of the container:

    $ echo 'meshuggah rocks' >> message

Finally, start your container and read the message:

    $ lxc start zesty
    $ lxc exec zesty cat /home/ubuntu/message
    meshuggah rocks

And enjoy the insighed offered to you by your home directory :)
