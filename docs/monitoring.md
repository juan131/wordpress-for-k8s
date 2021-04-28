# Monitoring

This solution makes use of the popular Prometheus + Grafana stack to manage application monitoring. In this stack, Prometheus is in charge of scraping metrics from each deployed container, while Grafana adds the capabilities to create nice dashboards and represents them in a powerful UI.

The following diagram illustrates how Prometheus scrapes the metrics from every container (see purple arrows), and how Grafana uses Prometheus as a "datasource" to populate its dashboards:

![Monitoring and logging](img/monitoring-and-logging.png)

## Prometheus

The solutions install the Prometheus Operator to deploy both Prometheus and Alertmanager.

Prometheus is automatically configured based on the "ServiceMonitor" and "PodMonitor" objects that are deployed. Each chart (WordPress, Memcached, MariaDB Galera, etc.) creates these objects so they're discoverable by Prometheus Operator. It's also a responsibility of every chart to expose the metrics to be scraped, this is done by using different "prometheus exporters" to adapt the metrics to PromQL (for instance, the [apache-exporter](https://github.com/Lusitaniae/apache_exporter) is used as a sidecar container to translate Apache metrics into sth that Prometheus understands).

Find more information about the Prometheus Operator in [GitHub](https://github.com/prometheus-operator/prometheus-operator).

## Grafana

The solution install the Grafana Operator to deploy Grafana.

The operator is also responsible of configuring Grafana with the datasources and dashboards to be used. Consult the [values.yaml](../values/grafana-operator-valeus.yaml) used to install the Grafana Operator, paying special attention to the "extraDeploy" parameter where the default datasources and dashboards are configured.

By default, this solution configure Grafana to use Prometheus as datasource and 3 dashboards:

- A generic dashboard with Kubernetes metrics (based on this [Pivotal dashboard](https://grafana.com/grafana/dashboards/10000)).
- One for MariaDB Galera metrics (based on this [Percona dashboard](https://grafana.com/grafana/dashboards/11323)).
- One for Apache metrics (based on this [Apache dashboard](https://grafana.com/grafana/dashboards/3894)).

Find more information about the Grafana Operator in [GitHub](https://github.com/integr8ly/grafana-operator).
