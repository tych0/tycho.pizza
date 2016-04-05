---
title: LXD networking: lxdbr0 explained
date: 2016-04-05
tags: containers, lxd, networking
---

Recently, LXD stopped depending on lxc, and thus moved to using its own bridge,
called `lxdbr0`. `lxdbr0` behaves significantly differently than `lxcbr0`: it
is ipv6 link local only by default (i.e. there is no ipv4 or ipv6 subnet
configured by default), and only HTTP traffic is proxied over the network. This
means that e.g. you can't SSH to your LXD containers with the default
configuration of lxdbr0.

The motivation for this change mostly to avoid picking subnets for users,
because this can cause breakage, and have users pick their own subnets.
Previously, the script that set up `lxcbr0` looked around on the host's
network, and picked the first 10.0.\*.1 address for the bridge that was
available. Of course, in some cases (e.g. networks which weren't visible at the
time of bridge creation) this can break routing for users' networks.

So, if you want to have parity with `lxcbr0`, you'll need to configure the
bridge yourself. There are a few ways to do this. For a step by step
walkthrough, simply do:

    sudo dpkg-reconfigure -p medium lxd

And answer the questions however you like. Alternatively, you can edit the file
`/etc/default/lxd-bridge` and then do a:

    sudo service lxd-bridge stop && sudo service lxd restart

For feature parity with `lxcbr0`, you can use something like the following
(note the 10.0.4.\*, so as not to conflict with `lxcbr0`):

    # Whether to setup a new bridge or use an existing one
    USE_LXD_BRIDGE="true"

    # Bridge name
    # This is still used even if USE_LXD_BRIDGE is set to false
    # set to an empty value to fully disable
    LXD_BRIDGE="lxdbr0"

    # Path to an extra dnsmasq configuration file
    LXD_CONFILE=""

    # DNS domain for the bridge
    LXD_DOMAIN="lxd"

    # IPv4
    ## IPv4 address (e.g. 10.0.4.1)
    LXD_IPV4_ADDR="10.0.4.1"

    ## IPv4 netmask (e.g. 255.255.255.0)
    LXD_IPV4_NETMASK="255.255.255.0"

    ## IPv4 network (e.g. 10.0.4.0/24)
    LXD_IPV4_NETWORK="10.0.4.1/24"

    ## IPv4 DHCP range (e.g. 10.0.4.2,10.0.4.254)
    LXD_IPV4_DHCP_RANGE="10.0.4.2,10.0.4.254"

    ## IPv4 DHCP number of hosts (e.g. 250)
    LXD_IPV4_DHCP_MAX="253"

    ## NAT IPv4 traffic
    LXD_IPV4_NAT="true"

    # IPv6
    ## IPv6 address (e.g. 2001:470:b368:4242::1)
    LXD_IPV6_ADDR=""

    ## IPv6 CIDR mask (e.g. 64)
    LXD_IPV6_MASK=""

    ## IPv6 network (e.g. 2001:470:b368:4242::/64)
    LXD_IPV6_NETWORK=""

    ## NAT IPv6 traffic
    LXD_IPV6_NAT="false"

    # Run a minimal HTTP PROXY server
    LXD_IPV6_PROXY="false"

And that's it! That's all you need to do to configure `lxdbr0`.

Sometimes, though, you don't really want your containers to live on a separate
network than the host because you want to ssh to them directly or something.
There are a few ways to accomplish this, the simplest is with macvlan:

    lxc profile device set default eth0 parent eth0
    lxc profile device set default eth0 nictype macvlan

Another way to do this is by adding another bridge which is bridged onto your
main NIC. You'll need to edit your `/etc/network/interfaces.d/eth0.cfg` to look
like this:

    # The primary network interface
    auto eth0
    iface eth0 inet manual # note the manual here

And then add a bridge by creating `/etc/network/interfaces.d/containerbr.cfg`
with the contents:

    auto containerbr
    iface containerbr inet dhcp
      bridge_ports eth0

Finally, you'll need to change the default lxd profile to use your new bridge:

    lxc profile device set default eth0 parent containerbr

Restart the `networking` service (which if you do it over ssh, may boot you :),
and away you go. If you want some of your containers to be on one bridge, and
some on the other, you can use different profiles to accomplish this.
