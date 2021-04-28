# Automatic horizontal scalability

In this solution, WordPress is dynamically scaled using an [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscaler). This solution allows tracking the CPU/RAM usage of the WordPress pods and **dynamicall** scale the solution based on that information.

You can find information about how the algorithm used for scaling up/down the solution works [in this link](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details).

The Horizontal Pod Autoscaler controller can retrieve metrics about the CPU/Memory consumption from several APIs, being the most important the ones that are provided by [Metrics Server](https://github.com/kubernetes-sigs/metrics-server) (this solution is available by default on GKE clusters). Find more information in the link below:

- [HPA supported APIs](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-metrics-apis)

Find below the specification of the "HorizontalPodAutoscaler" resource created with this solution:

```yaml
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wordpress
  minReplicas: 1
  maxReplicas: 11
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 50
    - type: Resource
      resource:
        name: memory
        targetAverageUtilization: 50
```
