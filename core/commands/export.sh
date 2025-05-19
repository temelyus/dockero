export() {
# === INPUT VALIDATION ===
if [[ ! -n "${args[1]}" ]]; then
  log.hint "Usage: $0 export <container-name>"
  exit 1
fi


# === PARAMETERS ===
container_name="${args[1]}"

# === PRE-CHECKS ===
if ! [[ $(docker ps -a --format '{{.Names}}' | grep "${container_name}" | head -n 1) == "${container_name}" ]]; then
  log.warn "Container '${container_name}' does not exists. Aborting."
  exit 1
fi

#image_name="$(docker inspect --format='{{.Config.Image}}' $(docker ps -aqf "name=${container_name}") 2>/dev/null)"
host_path="/opt/${container_name}/"
build_name="${container_name}.tar"

# === LOGGING ===
echo "🔧 Container       : ${container_name}"
echo "📦 Image Name      : ${container_name}"
echo "📁 Virtual Path    : ${host_path}:/workspace"
echo "🏗️  Build Name      : ${build_name}"

# === VERSIONED BUILD EXECUTION (vX Format) ===

log.info "Initiating container export with major versioning scheme..."

base_image="${container_name}"
commit_log="/tmp/export.${container_name}.log"

# Fetch all image tags in the format v<number>
existing_versions=$(docker images --format "{{.Repository}}:{{.Tag}}" \
    | grep "^${base_image}:" \
    | grep -Eo 'v[0-9]+' \
    | sort -V)

if [[ -z "$existing_versions" ]]; then
    next_version="v1"
else
    last_version=$(echo "$existing_versions" | tail -n 1)
    version_number=${last_version#v}
    next_version="v$((version_number + 1))"
fi

commit_image="${base_image}:${next_version}"
export_path="${HOME}/${container_name}-${next_version}.tar"

log.sub "Resolved image version: ${next_version}"

# Commit the container
if ! docker commit "$container_name" "$commit_image" 2> "$commit_log"; then
    log.error "Failed to commit container: $container_name"
    log.sub "Details logged at: $commit_log"
    exit 1
fi

log.info "Container committed successfully as: $commit_image"

# Export the image
if ! docker save -o "$export_path" "$commit_image" 2>> "$commit_log"; then
    log.error "Docker image export failed: $commit_image"
    log.sub "Details logged at: $commit_log"
    exit 1
fi

# Validate the tarball
if [[ -f "$export_path" ]]; then
    log.done "Image export successful: $export_path"
else
    log.error "Export verification failed. File not found: $export_path"
    log.sub "Details logged at: $commit_log"
    exit 1
fi

return 0
}