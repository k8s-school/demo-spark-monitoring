#!/bin/bash

kubectl delete sparkapplications.sparkoperator.k8s.io -l spark-app-name=spark-pi-prometheus
kubectl apply -f spark-prom/spark-pi-prometheus.yaml
kubectl wait --for=condition=running --timeout=600s sparkapplication/spark-pi-prometheus
kubectl exec -it -n spark spark-pi-prometheus-driver spark-pi-prometheus-driver -- curl http://localhost:8090