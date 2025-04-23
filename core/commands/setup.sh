setup() {
    [[ -z "${args[1]}" ]] && log.hint "setup <project path>" && return 1

    local project_path="${args[1]}"
    [[ "$project_path" != /* ]] && project_path="$PWD/$project_path"
    CONF_FILE="$project_path/.dockero"

    if ! [[ -d "$project_path" ]]; then
        log.warn "Project not found: ${project_path}"
        return 1
    elif ! [[ -f "$CONF_FILE" ]]; then
        log.warn ".dockero file not found in project path."
        return 1
    fi

    # Parse .dockero configuration
    local name image data port command
    name=$(inipars.get "default" "name")
    image=$(inipars.get "default" "image")
    command=$(inipars.get "default" "command")
    data=$(inipars.get "volumes" "data")
    port=$(inipars.get "volumes" "port")

    # Validate required fields
    if [[ -z "$name" || -z "$image" ]]; then
        log.error "Missing required fields in $CONF_FILE: 'name' or 'image'"
        return 1
    fi

    # Check container name if avaible
    if docker ps -a --format '{{.Names}}' | grep -q "^$name$"; then
        log.error "The container name "/mynode" is already in use"
        return 1
    fi

    log.setline "$name"

    # Pull image if not available locally
    if ! docker images --format '{{.Repository}}' | grep -q "^$image$"; then
        if docker pull "$image" > "/tmp/$image.pull.log" 2>&1; then
            log.done "$image pulled successfully."
        else
            log.error "Failed to pull image: $image"
            log.sub "Check log: /tmp/$image.pull.log"
            return 1
        fi
    fi

    # Set defaults and run container
    local volume_mount="${data:-$project_path:/workspace}"
    local port_mapping="${port:-80}"

    log.info "Launching container: $name"
    docker run -it \
        -v "$volume_mount" \
        -p "$port_mapping" \
        --name "$name" \
        "$image" ${command:+bash -c "$command"}
}
