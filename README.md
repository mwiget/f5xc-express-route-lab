# F5 XC Express Route Lab

## Topology

```
+- Spoke VNetA --+                             +--------------+
|                | \   +---------------+  BGP  |    Azure     |                 BGP                 +-----------+
| VM 1a-workload |  \  | azure-site-1  |.......| Route Server |.....................................|  SJC Lab  |
+----------------+   \ |   master-0    |       +--------------+                                     |           |   +--------+
                     / |   master-1    |       +--------------+                                     | DC Router |---| Lab VM |
+- Spoke VNetB --+  /  |   master-2    |-------|    Azure     |------{ Express Route Circuit }------|           |   +--------+
|                | /   +---------------+       | VNet Gateway |                                     +-----------+
| VM 1b-workload |                             +--------------+
+----------------+
```

