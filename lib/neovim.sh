detect_nvim_release() {
  case "${OS_ID}:${ARCH_ID}" in
    linux:x86_64)
      NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
      NVIM_EXTRACTED_DIR="nvim-linux-x86_64"
      NVIM_ARCHIVE_TYPE="tar.gz"
      ;;
    linux:arm64)
      NVIM_ARCHIVE="nvim-linux-arm64.tar.gz"
      NVIM_EXTRACTED_DIR="nvim-linux-arm64"
      NVIM_ARCHIVE_TYPE="tar.gz"
      ;;
    macos:x86_64)
      NVIM_ARCHIVE="nvim-macos-x86_64.tar.gz"
      NVIM_EXTRACTED_DIR="nvim-macos-x86_64"
      NVIM_ARCHIVE_TYPE="tar.gz"
      ;;
    macos:arm64)
      NVIM_ARCHIVE="nvim-macos-arm64.tar.gz"
      NVIM_EXTRACTED_DIR="nvim-macos-arm64"
      NVIM_ARCHIVE_TYPE="tar.gz"
      ;;
    windows:x86_64)
      NVIM_ARCHIVE="nvim-win64.zip"
      NVIM_EXTRACTED_DIR="nvim-win64"
      NVIM_ARCHIVE_TYPE="zip"
      ;;
    *)
      log_error "Unsupported OS/architecture pair: ${OS_ID}/${ARCH_ID}"
      exit 1
      ;;
  esac
}

configure_nvim_paths() {
  detect_nvim_release

  NVIM_HOME="${HOME}/.config/nvim-${NVIM_VERSION}"
  NVIM_BIN_DIR="${NVIM_HOME}/bin"
  NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCHIVE}"

  if is_windows; then
    NVIM_BIN="${NVIM_BIN_DIR}/nvim.exe"
  else
    NVIM_BIN="${NVIM_BIN_DIR}/nvim"
  fi
}

install_neovim() {
  local tmp_dir
  local archive_path
  local extract_dir
  local extracted_dir
  local extracted_bin

  tmp_dir="$(mktemp -d)"
  archive_path="${tmp_dir}/${NVIM_ARCHIVE}"
  extract_dir="${tmp_dir}/extract"
  extracted_dir="${extract_dir}/${NVIM_EXTRACTED_DIR}"

  if ! download_file "${NVIM_URL}" "${archive_path}"; then
    rm -rf "${tmp_dir}"
    log_error "Failed to download Neovim archive: ${NVIM_URL}"
    exit 1
  fi

  if ! extract_archive "${archive_path}" "${extract_dir}" "${NVIM_ARCHIVE_TYPE}"; then
    rm -rf "${tmp_dir}"
    log_error "Failed to extract Neovim archive: ${archive_path}"
    exit 1
  fi

  if is_windows; then
    extracted_bin="${extracted_dir}/bin/nvim.exe"
  else
    extracted_bin="${extracted_dir}/bin/nvim"
  fi

  if [ -f "${extracted_bin}" ]; then
    chmod +x "${extracted_bin}" 2>/dev/null || true
  fi

  if [ ! -x "${extracted_bin}" ]; then
    rm -rf "${tmp_dir}"
    log_error "Neovim binary not found after extraction: ${extracted_bin}"
    exit 1
  fi

  rm -rf "${NVIM_HOME}"
  mkdir -p "${NVIM_HOME}"

  mv "${extracted_dir}/"* "${NVIM_HOME}/"

  rm -rf "${tmp_dir}"

  log_info "Installed Neovim: ${NVIM_HOME}"
}

validate_nvim_binary() {
  if [ ! -x "${NVIM_BIN}" ]; then
    log_error "Neovim binary not found or not executable: ${NVIM_BIN}"
    exit 1
  fi

  local detected_version
  detected_version="$("${NVIM_BIN}" --version | awk 'NR==1 { print $2 }')"

  log_info "Detected Neovim version: ${detected_version}"

  if [ "${detected_version}" != "${NVIM_VERSION}" ]; then
    log_error "Neovim version mismatch."
    log_error "Expected: ${NVIM_VERSION}"
    log_error "Actual: ${detected_version}"
    exit 1
  fi
}
