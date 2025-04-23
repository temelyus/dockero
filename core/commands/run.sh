#!/usr/bin/env bash

run() {

  [[ -z "${args[1]}" ]] && log.hint "run <name> <image>" && return 1
  [[ -n ${params[@]} ]] && log.warn "run command cannot accept parameters!" && return 1

  local container_name=${args[1]}
  local image_name=${args[2]:-"${args[1]}"}

  # Check if container exists
  log.setline "$container_name"

  if docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
    docker start -ai "$container_name"
  elif docker images --format '{{.Repository}}' | grep -q "^$image_name$"; then
    log.sub "Creating new container from image: $image_name"
    docker run -it -v /opt/${container_name}:/workspace -p 80 --name "${container_name}" "$image_name"
  else
    log.warn "Image and Container not found. Pulling: $image_name"
    (docker pull "$image_name" > "/tmp/$image_name.pull.log" && log.done "$image_name installed.") || (log.error "Pulling $image_name" && log.sub "Log: /tmp/$image_name.pull.log" && exit 1)
    docker run -it -v /opt/${container_name}:/workspace -p 80 --name "${container_name}" "$image_name"
  fi
  log.endline "$container_name"
}
