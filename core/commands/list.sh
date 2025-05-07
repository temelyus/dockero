#!/usr/bin/env bash
list() {
  if [[ -n "${params[img]+set}" ]]; then
    docker ps -a --filter "ancestor=${params[img]}:latest"
    return 0
  fi

  if [[ "${args[1]}" =~ ("images"|"img") ]]; then
    docker images
  else
    printf "%-20s %-30s %-25s %-15s %-10s\n" "NAME" "IMAGE" "STATUS" "PORTS" "IP"

    while IFS= read -r container_id; do
      name=$(docker inspect -f '{{.Name}}' "$container_id" | cut -c2-)
      image=$(docker inspect -f '{{.Config.Image}}' "$container_id")
      status=$(docker inspect -f '{{.State.Status}}' "$container_id")
      ports=$(docker port "$container_id" 2>/dev/null | tr '\n' ' ')
      ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id")

      printf "%-20s %-30s %-25s %-15s %-10s\n" "$name" "$image" "$status" "$ports" "$ip"
    done < <(docker ps -aq)
  fi
}