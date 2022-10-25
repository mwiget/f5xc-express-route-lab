# F5 XC Express Route Lab

## Topology

```
+ Spoke VNetA +                            +--------------+
|      VM     | \   +--------------+  BGP  |    Azure     |       BGP        +---------+
| 1a-workload |  \  | azure-site-2 |.......| Route Server |..................| SJC Lab |
+-------------+   \ |   master-0   |       +--------------+                  |         |   +--------+
                  / |   master-1   |       +--------------+     Express      |   DC    |---| Lab VM |
+ Spoke VNetB +  /  |   master-2   |-------|    Azure     |---{  Route  }----|  Router |   +--------+
|      VM     | /   +--------------+       | VNet Gateway |     Circuit      +---------+
| 1b-workload |                            +--------------+
+-------------+
```

## Deploy

Set TF_VAR env or create terraform.tfvars (or use both) based on variables.tf. Then accept
the F5 XC Azure VM terms via shell script and deploy

```
./accept_azure_volterraedgeservices.sh
terraform init
terraform apply
```

