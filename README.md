# F5 XC Express Route Lab

## Topology

```
+- Spoke VNetA --+                             +--------------+
|                | \   +---------------+  BGP  |    Azure     |          BGP          +-----------+
| VM 1a-workload |  \  | azure-site-1  |.......| Route Server |.......................|  SJC Lab  |
+----------------+   \ |   master-0    |       +--------------+                       |           |   +--------+
                     / |   master-1    |       +--------------+        Express        | DC Router |---| Lab VM |
+- Spoke VNetB --+  /  |   master-2    |-------|    Azure     |------{  Route  }------|           |   +--------+
|                | /   +---------------+       | VNet Gateway |        Circuit        +-----------+
| VM 1b-workload |                             +--------------+
+----------------+
```

