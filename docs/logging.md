# Log collection & analysis

This solution makes use of a EFK (Elasticsearch + Fluentd + Grafana) for logs collection & analysis.

The following diagram illustrates how Fluentd collects/injects the logs in Elasticsearch (see green arrows), and how Kibana is used to analyze them:

![Monitoring and logging](img/monitoring-and-logging.png)

The solution is inspired in [this blog](https://docs.bitnami.com/tutorials/integrate-logging-kubernetes-kibana-elasticsearch-fluentd/). Refer to it for more information about the setup.
