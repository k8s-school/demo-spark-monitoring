#!/bin/bash

set -euxo pipefail

tag=1.4
image="fjammes/spark-pi-prom:$tag"

docker build . -t $image
docker push $image
