#!/usr/bin/env bash

list() {
  if [[  -n "${params[img]+set}" ]]; then
    docker ps -a --filter "ancestor=${params[img]}:latest"
    return 0
  fi

  if [[ "${args[1]}" =~ ("images"|"img") ]]; then
    docker images
  else
    docker ps -as --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
  fi
}
