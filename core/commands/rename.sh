rename() {
    if [[ -n "${args[1]}" && -n "${args[2]}" ]]; then
        local current_name="${args[1]}"
        local new_name="${args[2]}"

        # Check if new_name already exists as a container
        if docker ps -a --format '{{.Names}}' | grep -q "^${new_name}$"; then
            log.warn "A container with the name '${new_name}' already exists."
            return 1
        fi

        # Check if current_name exists as a container
        if docker ps -a --format '{{.Names}}' | grep -q "^${current_name}$"; then
            docker rename "${current_name}" "${new_name}"
            if [[ $? -eq 0 ]]; then
                log.done "Container '${current_name}' renamed to '${new_name}'."
                return 0
            else
                log.error "Failed to rename container '${current_name}'."
                return 1
            fi
        else
            log.error "Container '${current_name}' does not exist."
            return 1
        fi
    else
        log.hint "Usage: rename <name> <new name>"
        return 1
    fi
}
