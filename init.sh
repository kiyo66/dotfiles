#!/usr/bin/env bash
NVIM_VERSION="${NVIM_VERSION:-v0.12.0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

source "${LIB_DIR}/log.sh"
source "${LIB_DIR}/os.sh"
source "${LIB_DIR}/path.sh"
source "${LIB_DIR}/archive.sh"
source "${LIB_DIR}/link.sh"
source "${LIB_DIR}/fish.sh"
source "${LIB_DIR}/neovim.sh"

REPO_NVIM="${SCRIPT_DIR}/nvim"
REPO_FISH="${SCRIPT_DIR}/fish"
REPO_GHOSTTY="${SCRIPT_DIR}/ghostty"

OS_ID="$(detect_os)"
ARCH_ID="$(detect_arch)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

if is_windows; then
  LOCALAPPDATA_UNIX="$(path_from_windows_env LOCALAPPDATA)"

  if [ -z "${LOCALAPPDATA_UNIX}" ]; then
    LOCALAPPDATA_UNIX="${HOME}/AppData/Local"
  fi

  NVIM_CONFIG="${LOCALAPPDATA_UNIX}/nvim"
  FISH_CONFIG="${HOME}/.config/fish"
  GHOSTTY_CONFIG="${HOME}/.config/ghostty"
else
  NVIM_CONFIG="${XDG_CONFIG_HOME}/nvim"
  FISH_CONFIG="${XDG_CONFIG_HOME}/fish"
  GHOSTTY_CONFIG="${XDG_CONFIG_HOME}/ghostty"
fi

configure_nvim_paths

log_info "Detected OS: ${OS_ID}"
log_info "Detected architecture: ${ARCH_ID}"
log_info "Neovim version: ${NVIM_VERSION}"
log_info "Neovim URL: ${NVIM_URL}"
log_info "Neovim home: ${NVIM_HOME}"
log_info "Neovim binary: ${NVIM_BIN}"
log_info "Neovim config: ${NVIM_CONFIG}"
log_info "fish config: ${FISH_CONFIG}"
log_info "ghostty config: ${GHOSTTY_CONFIG}"

if [ ! -d "${REPO_NVIM}" ]; then
  log_error "Repository Neovim config directory not found: ${REPO_NVIM}"
  exit 1
fi

if [ ! -d "${REPO_FISH}" ]; then
  log_warn "Repository fish config directory not found: ${REPO_FISH}"
fi

if [ ! -d "${REPO_GHOSTTY}" ]; then
  log_warn "Repository ghostty config directory not found: ${REPO_GHOSTTY}"
fi

install_fish || true
install_neovim
validate_nvim_binary

make_link "${REPO_NVIM}" "${NVIM_CONFIG}"

if [ -d "${REPO_FISH}" ]; then
  if command -v fish >/dev/null 2>&1; then
    make_link "${REPO_FISH}" "${FISH_CONFIG}"
    generate_fish_nvim_path_config
  else
    log_warn "fish command not found. Skipping fish config link."
  fi
fi

if [ -d "${REPO_GHOSTTY}" ]; then
  make_link "${REPO_GHOSTTY}" "${GHOSTTY_CONFIG}"
fi

echo "[SUCCESS] Initialization complete."
