#!/bin/bash

set -euxo pipefail

tag=1.3
image="fjammes/spark-pi-prom:$tag"

docker build . -t $image
docker push $image
