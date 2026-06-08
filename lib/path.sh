path_from_windows_env() {
  local var_name="$1"
  local raw_value

  raw_value="$(printenv "${var_name}" 2>/dev/null || true)"

  if [ -n "${raw_value}" ] && command -v cygpath >/dev/null 2>&1; then
    cygpath -u "${raw_value}"
  else
    echo ""
  fi
}

resolve_path() {
  local path="$1"

  if command -v realpath >/dev/null 2>&1; then
    realpath "${path}"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "${path}"
  else
    local dir
    local base

    dir="$(dirname "${path}")"
    base="$(basename "${path}")"

    (
      cd "${dir}" 2>/dev/null && printf "%s/%s\n" "$(pwd -P)" "${base}"
    )
  fi
}

safe_resolve_path() {
  local path="$1"

  resolve_path "${path}" 2>/dev/null || printf "%s\n" "${path}"
}
