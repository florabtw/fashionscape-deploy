#! /bin/bash

MACHINE_NAME=fashionscape

pushd machine
machine-import $MACHINE_NAME.zip
popd

set -e

docker-machine ssh $MACHINE_NAME "mkdir -p /opt/traefik"

docker-machine scp ./acme.json $MACHINE_NAME:/opt/traefik/acme.json

docker-machine ssh $MACHINE_NAME "chmod 600 /opt/traefik/acme.json"

eval $(docker-machine env $MACHINE_NAME)

docker-compose pull

./scripts/up.sh
