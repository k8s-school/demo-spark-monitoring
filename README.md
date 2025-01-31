# How to setup spark monitoring

## Monitor an example application

See https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/getting-started.md

First install prometheus:

```bash
# serviceMonitorSelectorNilUsesHelmValues allow to monitor all serviceMonitors
helm upgrade --install --version "68.4.3" prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring --set  prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false --set  prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false --create-namespace
```

Then `Prometheus` contains an example for a monitoring application

```bash
kubectl apply -f Prometheus/ServiceMonitor-example
kubectl apply -f Prometheus/PodMonitor-example
```

## Create and push a spark image which embed prometheus agent

cf. `Dockerfile`

TODO: delete google deps and retry
TODO: check prom conf in `conf/`

## Monitor a spark example application

Check `spark-prom/spark-pi-prometheus.yaml` then launch a pod with the above image

TODO: write port-forward and curl command

Work in progress in `spark-prom`

See https://github.com/kubeflow/spark-operator/tree/master/examples

## Monitor fink

TODO