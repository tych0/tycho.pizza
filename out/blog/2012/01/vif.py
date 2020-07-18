#!/usr/bin/env python

"""
----------------------------------------------------------------------------
"THE BEER-WARE LICENSE" (Revision 42):
<tycho@tycho.ws> wrote this file. As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return. Tycho Andersen
(Shamelessly stolen from: http://people.freebsd.org/~phk/)
----------------------------------------------------------------------------
"""

import xmlrpclib
import sys

from socket import error

if __name__ == '__main__':
  try:
    proxy = xmlrpclib.ServerProxy("http://localhost:4596/RPC2")
    methods = proxy.system.listMethods()

    if len(sys.argv) == 1:
      print sys.argv[0], "[rpc_call(s)]"
      print "   availible methods are:"
      for method in methods:
        if not method.startswith('system.'):
          print '    ', method
    else:
      for method in sys.argv[1:]:
        if method not in methods:
          print 'invalid method'
          sys.exit(1)
        print getattr(proxy, method)()
  except error:
    print 'connection to server failed'
    sys.exit(1)
