#!/bin/bash

# Install a harbor registry from scratch

# @author  Fabrice Jammes

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)

$DIR/build.sh
$DIR/prereq.sh
$DIR/argocd.sh
kubectl exec -it -n spark spark-pi-driver -- curl http://localhost:8090
