#!/bin/bash

set -e

MACHINE_NAME=fashionscape

connect () {
  local OPTIND

  while getopts "aw" option; do
    case "$option" in
      a) connect_api;;
      w) connect_web;;
    esac
  done
}

connect_api () {
  docker exec -it        \
    fashionscape-api     \
    bash
}

connect_web () {
  docker exec -it        \
    fashionscape-web     \
    bash
}

down () {
  docker-compose down
}

logs () {
  docker-compose logs $@
}

show_help () {
  echo "Invalid target. Please specify staging or production."
  echo "example: ./scripts/machine -e staging <command>"
}

pull () {
  local OPTIND

  while getopts "a" option; do
    case "$option" in
      a) pull_acme;;
    esac
  done
}

pull_acme () {
  docker-machine scp $MACHINE_NAME:/opt/traefik/acme.json acme.json
}

push () {
  local OPTIND

  docker-machine ssh $MACHINE_NAME "mkdir -p /opt/brandnewcongress"

  while getopts "a-:" option; do
    case "$option" in
      -)
        if [ "$OPTARG" == "all" ]; then
          push_acme
        fi
        ;;
      a) push_acme;;
    esac
  done
}

push_acme () {
  docker-machine scp acme.json $MACHINE_NAME:/opt/traefik/acme.json
  docker-machine ssh $MACHINE_NAME "chmod 600 /opt/traefik/acme.json"
}

restart () {
  docker-compose restart $@
}

recreate () {
  docker-compose up      \
    --force-recreate     \
    --renew-anon-volumes \
    --detach             \
    $@
}

use_machine () {
  eval $(docker-machine env $MACHINE_NAME)
}

up () {
  docker-compose up -d $@
}

COMMAND="$1"
shift

case "$COMMAND" in
  connect) connect $@;;
  deploy)
    push --all
    use_machine
    up
    ;;
  down)
    use_machine
    down
    ;;
  logs)
    use_machine
    logs $@
    ;;
  pull)
    pull $@
    ;;
  push)
    push $@
    ;;
  recreate)
    use_machine
    recreate $@
    ;;
  restart)
    use_machine
    restart $@
    ;;
  up)
    use_machine
    up $@
    ;;
esac
