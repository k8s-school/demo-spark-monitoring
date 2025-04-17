ARG SPARK_IMAGE=docker.io/spark:3.4.1
FROM ${SPARK_IMAGE}

# Switch to user root so we can add additional jars and configuration files.
USER root

USER ${spark_uid}

ENTRYPOINT ["/opt/entrypoint.sh"]
