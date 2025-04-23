#!/usr/bin/env bash

# === Project Root Detection ===
CORE_DIR="$(dirname $0)"
COMMANDS_DIR="${CORE_DIR}/core/commands"
[[ "$0" =~ "core/" ]] && COMMANDS_DIR="${CORE_DIR}/commands"

# === sources ===
source ${CORE_DIR}/extra/log.sh
source ${CORE_DIR}/extra/inipars.sh
source ${CORE_DIR}/parameter-indexing.sh
parameter-indexing $@

# === Version Info ===
DOCKERO_VERSION="0.1.0"

# === Dynamic Command Loader ===
load_command() {
  local cmd_file="${COMMANDS_DIR}/${1}.sh"
  if [[ -f "$cmd_file" ]]; then
    source "$cmd_file"
    "${1}" "${@:2}"
  else
    log.error "Unknown command '$1'"
    log.hint "Run '$0 -h' for usage."
    exit 1
  fi
}

# === Entrypoint ===

if [[ -n "${params[v]+set}" || -n "${params[version]+set}" || "${args[0]}" == 'version' ]]; then
  log.info "Dockero CLI v$DOCKERO_VERSION"
  exit 0
elif [[ -n "${params[h]+set}"  || -n "${params[help]+set}" || -z "${args[0]}" ]]; then
   source "${COMMANDS_DIR}/help.sh"
   help-${args[0]}
   log.setline
   exit 0
fi

load_command "${args[0]}"

