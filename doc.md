## Monitoring Spark Applications with Prometheus and JMX Exporter

Spark Operator supports exporting Spark metrics in Prometheus format using the [JMX Prometheus Exporter](https://github.com/prometheus/jmx_exporter). This allows detailed monitoring of your Spark drivers and executors with tools like Prometheus and Grafana.

> 🛠️ **Note**: The older documentation in [Kubeflow's monitoring section](https://kubeflow.github.io/spark-operator/docs/user-guide.html#monitoring) is outdated and no longer works with recent Spark images. This guide provides a modern, functional example.

---

### 1. Build a Spark Image with the JMX Exporter Jar

Start by building a custom Docker image that includes the JMX Prometheus Java agent.

**Dockerfile example:**

```Dockerfile
ARG SPARK_IMAGE=docker.io/spark:3.4.1
FROM ${SPARK_IMAGE}

# Switch to user root so we can add additional jars and configuration files.
USER root

# Setup for the Prometheus JMX exporter.
# Add the Prometheus JMX exporter Java agent jar for exposing metrics sent to the JmxSink to Prometheus.
ENV JMX_EXPORTER_AGENT_VERSION 1.1.0
ADD https://github.com/prometheus/jmx_exporter/releases/download/${JMX_EXPORTER_AGENT_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_AGENT_VERSION}.jar /opt/spark/jars
RUN chmod 644 /opt/spark/jars/jmx_prometheus_javaagent-${JMX_EXPORTER_AGENT_VERSION}.jar

USER ${spark_uid}
```

Build and push your image:

```bash
docker build -t <your-repo>/spark-jmx:3.4.1 .
docker push <your-repo>/spark-jmx:3.4.1
```

---

### 2. Enable JMX Exporter in Your SparkApplication YAML

Use the `monitoring.prometheus` block to instruct the operator to launch the JMX exporter for both driver and executor containers.

**Updated SparkApplication YAML:**

```yaml
apiVersion: "sparkoperator.k8s.io/v1beta2"
kind: SparkApplication
metadata:
  name: spark-pi
spec:
  type: Java
  mode: cluster
  image: "<your-repo>/spark-jmx:3.4.1"
  imagePullPolicy: Always
  mainClass: org.apache.spark.examples.SparkPi
  mainApplicationFile: "local:///opt/spark/examples/jars/spark-examples_2.12-3.4.1.jar"
  sparkVersion: "3.4.1"
  driver:
    cores: 1
    coreLimit: "1200m"
    memory: "512m"
    labels:
      version: 3.4.1
    serviceAccount: spark-operator-spark
  executor:
    cores: 1
    instances: 1
    memory: "512m"
    labels:
      version: 3.4.1
  monitoring:
    exposeDriverMetrics: true
    exposeExecutorMetrics: true
    prometheus:
      jmxExporterJar: "/opt/spark/jars/jmx_prometheus_javaagent-1.1.0.jar"
      port: 8090
```

This config will:

- Launch the JMX exporter on port `8090` inside each Spark container
- Use the jar included in your custom image

> 🚨 Ensure that the JAR path and port **match** what was used during the Docker build.

---

### 3. Prometheus Configuration

Configure Prometheus to scrape the metrics exposed by the Spark pods. You can use `PodMonitor`

**Basic example (ServiceMonitor):**

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: spark-pi
spec:
  selector:
    matchExpressions:
      - key: "spark-role"
        operator: "Exists"
  podMetricsEndpoints:
  - port: "8090"
```

Make sure your SparkApplication pods are labeled appropriately for scraping.

---

### Summary

| Step | Description |
|------|-------------|
| 1️⃣  | Build a custom Spark image with `jmx_prometheus_javaagent` |
| 2️⃣  | Use the `monitoring.prometheus` section in your SparkApplication |
| 3️⃣  | Configure Prometheus to scrape metrics from `8090` port |

This updated process ensures metrics collection works reliably with the latest Spark Operator releases and resolves [Issue #2380](https://github.com/kubeflow/spark-operator/issues/2380).