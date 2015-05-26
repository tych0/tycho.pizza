---
title: Using the LXD API from Python
date: 2015-05-26
tags: linux, lxd, containers, python
---

After our recent splash at ODS in Vancouver, it seems that there is a lot of
interest in writing some python code to drive LXD to do various things. The
first option is to use [pylxd](https://github.com/lxc/pylxd), a project
maintained by a friend of mine at Canonical named Chuck Short. However, the
primary client of this is OpenStack, and thus it is python2. We also don't want
to add a lot of dependencies in this module, so we're using raw python urllib
and friends, which as you know can sometimes be...painful :)

Another option would be to use python's awesome
[requests](http://python-requests.org) module, which is considerably more user
friendly. However, since LXD uses client certificates, it can be a bit
challenging to get the basic bits going. Here's a small program that just does
some GETs to the API, to see how it might work:

    import os.path

    import requests

    conf_dir = os.path.expanduser('~/.config/lxc')
    crt = os.path.join(conf_dir, 'client.crt')
    key = os.path.join(conf_dir, 'client.key')

    print(requests.get('https://127.0.0.1:8443/1.0', verify=False, cert=(crt, key)).text)

which gives me (piped through jq for sanity):

    $ python3 lxd.py | jq .
    {
      "type": "sync",
      "status": "Success",
      "status_code": 200,
      "metadata": {
        "api_compat": 1,
        "auth": "trusted",
        "config": {
          "trust-password": true
        },
        "environment": {
          "backing_fs": "ext4",
          "driver": "lxc",
          "kernel_version": "3.19.0-15-generic",
          "lxc_version": "1.1.2",
          "lxd_version": "0.9"
        }
      }
    }

It just piggy backs on the lxc client generated certificates for now, but it
would be great to have some python code that could generate those as well!

Another bit I should point out for people is lxd's `--debug` flag, which prints
out every request it receives and response that it sends. I found this useful
while developing the default `lxc` client, and it will probably be useful to
those of you out there who are developing your own clients.

Happy hacking!
