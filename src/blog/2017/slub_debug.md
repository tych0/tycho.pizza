---
title: Just how expensive is slub_deug=p?
date: 2017-03-31
tags: linux, kernel, security
---

Recently, I became interested in a debugging option in the Linux kernel

### slub\_debug=p

```
Average Half load -j 2 Run (std deviation):
Elapsed Time 44.586 (1.67125)
User Time 73.874 (2.51294)
System Time 7.756 (0.741741)
Percent CPU 182.4 (0.547723)
Context Switches 13880.8 (157.161)
Sleeps 15745.2 (24.3146)

Average Optimal load -j 4 Run (std deviation):
Elapsed Time 32.702 (0.400087)
User Time 89.22 (16.3062)
System Time 8.945 (1.37014)
Percent CPU 266.4 (88.5729)
Context Switches 15701 (1929.57)
Sleeps 15722.2 (78.1875)
```

### without slub\_debug=p

```
Average Half load -j 2 Run (std deviation):
Elapsed Time 40.614 (0.232873)
User Time 69.978 (0.503061)
System Time 5.09 (0.182209)
Percent CPU 184.4 (0.547723)
Context Switches 13596 (121.501)
Sleeps 15740.4 (46.4629)

Average Optimal load -j 4 Run (std deviation):
Elapsed Time 30.622 (0.171523)
User Time 86.233 (17.1381)
System Time 5.874 (0.853557)
Percent CPU 270.1 (90.3431)
Context Switches 15370.3 (1875.97)
Sleeps 15777.4 (74.43)
```

