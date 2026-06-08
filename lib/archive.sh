download_file() {
  local url="$1"
  local output="$2"
  local tmp_output

  tmp_output="${output}.tmp"

  rm -f "${tmp_output}" "${output}"

  if command -v curl >/dev/null 2>&1; then
    if ! curl -fL \
      --retry 5 \
      --retry-all-errors \
      --retry-delay 2 \
      --connect-timeout 20 \
      --max-time 600 \
      -o "${tmp_output}" \
      "${url}"; then
      rm -f "${tmp_output}"
      return 1
    fi
  elif command -v wget >/dev/null 2>&1; then
    if ! wget \
      --tries=5 \
      --timeout=20 \
      --waitretry=2 \
      -O "${tmp_output}" \
      "${url}"; then
      rm -f "${tmp_output}"
      return 1
    fi
  else
    log_error "curl or wget is required."
    return 1
  fi

  if [ ! -s "${tmp_output}" ]; then
    rm -f "${tmp_output}"
    return 1
  fi

  mv "${tmp_output}" "${output}"
}

extract_archive() {
  local archive="$1"
  local dest="$2"
  local type="$3"

  if [ ! -s "${archive}" ]; then
    log_error "Archive file does not exist or is empty: ${archive}"
    return 1
  fi

  mkdir -p "${dest}"

  case "${type}" in
    tar.gz)
      tar -xzf "${archive}" -C "${dest}"
      ;;
    zip)
      if command -v unzip >/dev/null 2>&1; then
        unzip -q "${archive}" -d "${dest}"
      elif command -v powershell.exe >/dev/null 2>&1 && command -v cygpath >/dev/null 2>&1; then
        local win_archive
        local win_dest

        win_archive="$(cygpath -w "${archive}")"
        win_dest="$(cygpath -w "${dest}")"

        powershell.exe -NoProfile -ExecutionPolicy Bypass \
          -Command "Expand-Archive -LiteralPath '${win_archive}' -DestinationPath '${win_dest}' -Force"
      else
        log_error "unzip or powershell.exe is required to extract zip archives."
        return 1
      fi
      ;;
    *)
      log_error "Unsupported archive type: ${type}"
      return 1
      ;;
  esac
}
