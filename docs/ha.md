# High Availability

Both WordPress and MariaDB Galera use a HA setup with several replicas available where to load-balance the difference requests that are received.

Check the diagram below to graphically understand the architecture:

![Database and Cache](img/database-and-cache.png)

WordPress uses a NFS disk to share/sync the "wp-content" data across the replicas.

> Note: your K8s cluster should have support for this "ReadWriteMany" volumes. You can use the [](https://github.com/kubernetes-retired/external-storage/tree/master/nfs) to provide this capability.

In the case of MariaDB Galera, it uses a "multi-master" cluster setup with ability to sync data about the replicas. Refer to the [MariaDB Galera chart docs](https://github.com/bitnami/charts/tree/master/bitnami/mariadb-galera) for more information.
