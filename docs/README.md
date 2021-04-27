# Available features

## High availability

Both WordPress and MariaDB Galera are deployed with HA and load balancing capabilities, so it guarantees the availability of the blog site.

Please refer to the [High Availability Guide](ha.md) for detailed information.

## Automatic horizontal scalability

WordPress is configured to dynamically scale the solution horizontally based on the CPU and memory consumption of the WordPress pods.

Please refer to the [Horizontal Scalability Guide](scaling.md) for detailed information.

## Caching database queries and objects

WordPress is configured to activate the W3 Total Cache plugin and configure it to use a Memcached server for database caching.

Please refer to the [Caching Guide](caching.md) for detailed information.

## Monitoring

All the components included in the solution are configured to expose Prometheus metrics, and they're integrated with Prometheus so it can scrape these metrics periodically. The solution also includes Grafana with available dashboards to visualize the metrics.

Please refer to the [Monitoring Guide](monitoring.md) for detailed information.

## Log collection & analysis

The solution deploys a EFK (Elasticsearch + Fluentd + Kibana) stack configured to collect the logs if every container and make them available for inspection and visualization.

Please refer to the [Logging Guide](logging.md) for detailed information.

## Blog exposure and TLS certificates management and issuance

The solution makes use of the cert-manager, external-dns and ingress resources to expose the blog site externally through HTTPS.

Please refer to the [TLS Management Guide](exposure-and-tls.md) for detailed information.
