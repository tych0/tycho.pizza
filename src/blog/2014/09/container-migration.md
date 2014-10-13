---
title: Live Migration of Linux Containers
date: 2014-10-08
tags: linux, containers, migration, lxc, criu
---

Recently, I've been playing around with [checkpoint and restore][1] of [Linux
containers][2]. One of the obvious applications is checkpointing on one host
and restoring on another (i.e. live migration). Live migration has all sorts of
interesting applications, so it is nice to know that at least a proof of
concept of it works today.

Anyway, onto the interesting bits! The first thing I did was create two vms,
and install criu's and lxc's development versions on both hosts:

    sudo add-apt-repository ppa:ubuntu-lxc/daily
    sudo apt-get update
    sudo apt-get install lxc

    sudo apt-get install build-essential protobuf-c-compiler
    git clone https://github.com/xemul/criu && cd criu && sudo make install

Then, I created a container:

    sudo lxc-create -t ubuntu -n u1 -- -r trusty -a amd64

Since the work on container checkpoint/restore is so young, not all container
configurations are supported. In particular, I had to add the following to my
config:

    cat | sudo tee -a /var/lib/lxc/u1/config << EOF
    # hax for criu
    lxc.console = none
    lxc.tty = 0
    lxc.cgroup.devices.deny = c 5:1 rwm
    EOF

Finally, although the lxc-checkpoint tool allows us to checkpoint and restore
containers, there is no support for migration directly today. There are several
tools in the works for this, but for now we can just use a cheesy shell script:

    cat > migrate <<EOF
    #!/bin/sh
    set -e

    usage() {
      echo $0 container user@host.to.migrate.to
      exit 1
    }

    if [ "$(id -u)" != "0" ]; then
      echo "ERROR: Must run as root."
      usage
    fi

    if [ "$#" != "2" ]; then
      echo "Bad number of args."
      usage
    fi

    name=$1
    host=$2

    checkpoint_dir=/tmp/checkpoint

    do_rsync() {
      rsync -rltzh --progress --devices --rsync-path="sudo rsync" $1 $host:$1
    }

    # we assume the same lxcpath on both hosts, that is bad.
    LXCPATH=$(lxc-config lxc.lxcpath)

    lxc-checkpoint -n $name -D $checkpoint_dir -s -v

    do_rsync $LXCPATH/$name/
    do_rsync $checkpoint_dir/

    ssh $host "sudo lxc-checkpoint -r -n $name -D $checkpoint_dir -v"
    ssh $host "sudo lxc-wait -n u1 -s RUNNING"
    EOF
    chmod +x migrate

Now, for the magic show! I've set up the container I created above to be a web
server running micro-httpd that serves an incredibly important message:

    $ ssh ubuntu@$(sudo lxc-info -n u1 -H -i)
    ubuntu@u1:~$ sudo apt-get install micro-httpd
    ubuntu@u1:~$ echo "Meshuggah is the best metal band." | sudo tee /var/www/index.html
    ubuntu@u1:~$ exit
    $ curl -s $(sudo lxc-info -n u1 -H -i)
    Meshuggah is the best metal band.

Let's migrate!

    $ sudo ./migrate u1 ubuntu@criu2.local
      # lots of rsync output...
    $ ssh ubuntu@criu2.local 'curl -s $(sudo lxc-info -n u1 -H -i)'
    Meshuggah is the best metal band.

Of course, there are several caveats to this. You've got to add the lines above
to your config, which means you can't dump containers with ttys. Since
containers have the hosts's fusectl bind mounted and fuse mounts aren't
supported by criu, containers or hosts using fuse can't be dumped. You can't
migrate unprivileged containers yet. There are probably others that I'm
forgetting, though list of troubleshoting steps is available at
[criu.org/LXC#Troubleshooting][3].

There is ongoing work in both CRIU and LXC to get rid of all the caveats above,
so stay tuned!

[1]: http://criu.org
[2]: http://linuxcontainers.org
[3]: http://criu.org/LXC#Troubleshooting
