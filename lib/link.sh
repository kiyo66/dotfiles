create_windows_junction() {
  local target="$1"
  local link="$2"

  if ! command -v powershell.exe >/dev/null 2>&1 || ! command -v cygpath >/dev/null 2>&1; then
    return 1
  fi

  local win_target
  local win_link

  win_target="$(cygpath -w "${target}")"
  win_link="$(cygpath -w "${link}")"

  powershell.exe -NoProfile -ExecutionPolicy Bypass \
    -Command "New-Item -ItemType Junction -Path '${win_link}' -Target '${win_target}' -Force | Out-Null"
}

backup_existing_path() {
  local path="$1"
  local backup

  backup="${path}.bak.$(date +%Y%m%d%H%M%S)"

  log_warn "Existing path found: ${path}"
  log_warn "Moving it to backup: ${backup}"

  mv "${path}" "${backup}"
}

make_link() {
  local target="$1"
  local link="$2"
  local target_resolved

  if [ ! -e "${target}" ]; then
    log_error "Link target does not exist: ${target}"
    exit 1
  fi

  target_resolved="$(resolve_path "${target}")"

  mkdir -p "$(dirname "${link}")"

  if [ -L "${link}" ]; then
    local current_target
    local current_resolved

    current_target="$(readlink "${link}")"
    current_resolved="$(safe_resolve_path "${link}")"

    if [ "${current_resolved}" = "${target_resolved}" ]; then
      log_info "Link OK: ${link} -> ${target_resolved}"
      return 0
    fi

    log_warn "Replacing existing symlink: ${link} -> ${current_target}"
    rm -f "${link}"
  elif [ -e "${link}" ]; then
    backup_existing_path "${link}"
  fi

  if is_windows && [ -d "${target_resolved}" ]; then
    if create_windows_junction "${target_resolved}" "${link}"; then
      log_info "Created Windows junction: ${link} -> ${target_resolved}"
      return 0
    fi
  fi

  ln -s "${target_resolved}" "${link}"
  log_info "Created symlink: ${link} -> ${target_resolved}"
}
