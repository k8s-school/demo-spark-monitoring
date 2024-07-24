# How to setup spark monitoring

## Monitor an example application

See https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/getting-started.md

First install prometheus:

```bash
# serviceMonitorSelectorNilUsesHelmValues allow to monitor all serviceMonitors
helm install --version "61.3.1" prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring --set  prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
```

Then `ServiceMonitor-example` contains an example for a monitoring application

```bash
kubectl apply -f Prometheus/ServiceMonitor-example
```

## Create and push a spark image which embed prometheus agent

cf. `Dockerfile`

TODO: delete google deps and retry
TODO: check prom conf in `conf/`

## Monitor a spark example application

Check `spark-prom/spark-pi-prometheus.yaml` then launch a pod with the above image

Work in progress in `spark-prom`

See https://github.com/kubeflow/spark-operator/tree/master/examples

## Monitor fink

TODO