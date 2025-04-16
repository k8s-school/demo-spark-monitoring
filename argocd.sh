#!/bin/bash

# Install pre-requisite for fink ci

# @author  Fabrice Jammes

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)

src_dir=$DIR

export CIUXCONFIG=$HOME/.ciux/ciux.sh

ciux ignite --selector itest "$src_dir"
# Run the CD pipeline
. $CIUXCONFIG

NS=argocd

argocd login --core
kubectl config set-context --current --namespace="$NS"

APP_NAME="$CIUX_IMAGE_NAME"
WORKBRANCH="$DEMO_SPARK_MONITORING_WORKBRANCH"

argocd app create $APP_NAME --dest-server https://kubernetes.default.svc \
    --dest-namespace "$APP_NAME" \
    --repo https://github.com/k8s-school/$APP_NAME \
    --path charts/apps --revision "$WORKBRANCH" \
    -p spec.source.targetRevision.default="$WORKBRANCH"

argocd app sync $APP_NAME

argocd app set $APP_NAME -p image.tag="$CIUX_IMAGE_TAG"

argocd app sync -l app.kubernetes.io/part-of=$APP_NAME,app.kubernetes.io/component=operator
argocd app wait -l app.kubernetes.io/part-of=$APP_NAME,app.kubernetes.io/component=operator

argocd app sync -l app.kubernetes.io/part-of=$APP_NAME


