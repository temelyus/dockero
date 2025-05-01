remove() {
  local targets=("${full_arr[@]:1}")

  if [[ ${#targets[@]} -eq 0 ]]; then
    log.hint "Usage: remove <container|image> [additional]"
    return 1
  fi

  for target in "${targets[@]}"; do
    if docker ps -a --format '{{.Names}}' | grep -q "^$target$"; then
      docker rm -f "$target" && log.done "Removed container: $target" || log.warn "Failed to remove container: $target"
    elif docker images --format '{{.Repository}}' | grep -q "^$target$"; then
      docker rmi -f "$target" && log.done "Removed image: $target" || log.warn "Failed to remove image: $target"
    else
      log.error "Target not found: $target"
    fi
  done
}
