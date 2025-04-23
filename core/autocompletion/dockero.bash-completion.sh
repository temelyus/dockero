#!/usr/bin/env bash

_dockero_autocomplete() {
  local cur prev opts containers
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="run list stop start export rename setup remove --help --version"

  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  elif [[ "$prev" =~ ("run"|"rename"|"start"|"export"|"remove") ]]; then
    containers=$(docker ps -as --format "{{.Names}}")
    COMPREPLY=( $(compgen -W "${containers}" -- ${cur}) )
  elif [[ "$prev" =~ ("stop") ]]; then
    containers=$(docker ps --filter "status=running" --format '{{.Names}}')
    COMPREPLY=( $(compgen -W "${containers}" -- ${cur}) )
  fi
}

complete -F _dockero_autocomplete dockero
