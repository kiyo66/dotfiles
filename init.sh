#!/usr/bin/env bash
NVIM_VERSION="${NVIM_VERSION:-v0.12.0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_NVIM="${SCRIPT_DIR}/nvim"
REPO_FISH="${SCRIPT_DIR}/fish"

log_info() { echo "[INFO] $*"; }
log_warn() { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

detect_os() {
  local uname_s
  uname_s="$(uname -s)"

  case "${uname_s}" in
    Linux*)
      echo "linux"
      ;;
    Darwin*)
      echo "macos"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "windows"
      ;;
    *)
      log_error "Unsupported OS: ${uname_s}"
      exit 1
      ;;
  esac
}

detect_arch() {
  local uname_m
  uname_m="$(uname -m)"

  case "${uname_m}" in
    x86_64|amd64)
      echo "x86_64"
      ;;
    arm64|aarch64)
      echo "arm64"
      ;;
    *)
      log_error "Unsupported architecture: ${uname_m}"
      exit 1
      ;;
  esac
}

is_windows() {
  [ "${OS_ID}" = "windows" ]
}

path_from_windows_env() {
  local var_name="$1"
  local raw_value="${!var_name:-}"

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

download_file() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 --connect-timeout 20 -o "${output}" "${url}"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "${url}" -O "${output}"
  else
    log_error "curl or wget is required."
    exit 1
  fi
}

extract_archive() {
  local archive="$1"
  local dest="$2"
  local type="$3"

  mkdir -p "${dest}"

  case "${type}" in
    tar.gz)
      tar -xzf "${archive}" -C "${dest}"
      ;;
    zip)
      if command -v unzip >/dev/null 2>&1; then
        unzip -q "${archive}" -d "${dest}"
      elif command -v powershell.exe >/dev/null 2>&1; then
        local win_archive
        local win_dest
        win_archive="$(cygpath -w "${archive}")"
        win_dest="$(cygpath -w "${dest}")"
        powershell.exe -NoProfile -ExecutionPolicy Bypass \
          -Command "Expand-Archive -LiteralPath '${win_archive}' -DestinationPath '${win_dest}' -Force"
      else
        log_error "unzip or powershell.exe is required to extract zip archives."
        exit 1
      fi
      ;;
    *)
      log_error "Unsupported archive type: ${type}"
      exit 1
      ;;
  esac
}

install_fish() {
  if command -v fish >/dev/null 2>&1; then
    log_info "fish already installed."
    return 0
  fi

  log_info "fish not found. Installing..."

  case "${OS_ID}" in
    linux)
      if command -v apt-get >/dev/null 2>&1; then
        run_as_root apt-get update
        run_as_root apt-get install -y fish
      elif command -v dnf >/dev/null 2>&1; then
        run_as_root dnf install -y fish
      elif command -v yum >/dev/null 2>&1; then
        run_as_root yum install -y fish
      elif command -v pacman >/dev/null 2>&1; then
        run_as_root pacman -Sy --needed --noconfirm fish
      else
        log_warn "Unsupported Linux package manager. Please install fish manually."
        return 1
      fi
      ;;

    macos)
      if command -v brew >/dev/null 2>&1; then
        brew install fish
      else
        log_warn "Homebrew not found. Please install fish manually: https://fishshell.com/"
        return 1
      fi
      ;;

    windows)
      if command -v pacman >/dev/null 2>&1; then
        pacman -Sy --needed --noconfirm fish
      else
        log_warn "Automatic fish installation on Windows requires MSYS2 pacman."
        log_warn "If you are using WSL, run this script inside WSL instead."
        return 1
      fi
      ;;
  esac
}

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
  local backup="${path}.bak.$(date +%Y%m%d%H%M%S)"

  log_warn "Existing path found: ${path}"
  log_warn "Moving it to backup: ${backup}"

  mv "${path}" "${backup}"
}

make_link() {
  local target="$1"
  local link="$2"

  if [ ! -e "${target}" ]; then
    log_error "Link target does not exist: ${target}"
    exit 1
  fi

  mkdir -p "$(dirname "${link}")"

  if [ -L "${link}" ]; then
    local current_target
    current_target="$(readlink "${link}")"

    if [ "${current_target}" = "${target}" ]; then
      log_info "Link OK: ${link} -> ${target}"
      return 0
    fi

    rm -f "${link}"
  elif [ -e "${link}" ]; then
    backup_existing_path "${link}"
  fi

  if is_windows && [ -d "${target}" ]; then
    if create_windows_junction "${target}" "${link}"; then
      log_info "Created Windows junction: ${link} -> ${target}"
      return 0
    fi
  fi

  ln -s "${target}" "${link}"
  log_info "Created symlink: ${link} -> ${target}"
}

install_neovim() {
  if [ -x "${NVIM_BIN}" ]; then
    log_info "Neovim ${NVIM_VERSION} already present at ${NVIM_BIN}"
    return 0
  fi

  log_info "Fetching Neovim ${NVIM_VERSION} from ${NVIM_URL}"

  local tmp_dir
  local archive_path

  tmp_dir="$(mktemp -d)"
  archive_path="${tmp_dir}/${NVIM_ARCHIVE}"

  download_file "${NVIM_URL}" "${archive_path}"

  rm -rf "${NVIM_HOME}"
  mkdir -p "${NVIM_HOME}"

  extract_archive "${archive_path}" "${NVIM_HOME}" "${NVIM_ARCHIVE_TYPE}"

  rm -rf "${tmp_dir}"

  if [ -f "${NVIM_BIN}" ]; then
    chmod +x "${NVIM_BIN}" 2>/dev/null || true
  fi

  if [ ! -x "${NVIM_BIN}" ]; then
    log_error "Neovim binary not found after extraction: ${NVIM_BIN}"
    exit 1
  fi

  log_info "Neovim installed under ${NVIM_HOME}"
}

OS_ID="$(detect_os)"
ARCH_ID="$(detect_arch)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"

case "${OS_ID}:${ARCH_ID}" in
  linux:x86_64)
    NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
    NVIM_DIR="nvim-linux-x86_64"
    NVIM_ARCHIVE_TYPE="tar.gz"
    ;;
  linux:arm64)
    NVIM_ARCHIVE="nvim-linux-arm64.tar.gz"
    NVIM_DIR="nvim-linux-arm64"
    NVIM_ARCHIVE_TYPE="tar.gz"
    ;;
  macos:x86_64)
    NVIM_ARCHIVE="nvim-macos-x86_64.tar.gz"
    NVIM_DIR="nvim-macos-x86_64"
    NVIM_ARCHIVE_TYPE="tar.gz"
    ;;
  macos:arm64)
    NVIM_ARCHIVE="nvim-macos-arm64.tar.gz"
    NVIM_DIR="nvim-macos-arm64"
    NVIM_ARCHIVE_TYPE="tar.gz"
    ;;
  windows:x86_64)
    NVIM_ARCHIVE="nvim-win64.zip"
    NVIM_DIR="nvim-win64"
    NVIM_ARCHIVE_TYPE="zip"
    ;;
  windows:arm64)
    log_error "Neovim Windows ARM64 release archive is not handled by this script."
    exit 1
    ;;
  *)
    log_error "Unsupported OS/architecture pair: ${OS_ID}/${ARCH_ID}"
    exit 1
    ;;
esac

NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCHIVE}"

if is_windows; then
  LOCALAPPDATA_UNIX="$(path_from_windows_env LOCALAPPDATA)"

  if [ -z "${LOCALAPPDATA_UNIX}" ]; then
    LOCALAPPDATA_UNIX="${HOME}/AppData/Local"
  fi

  NVIM_HOME="${LOCALAPPDATA_UNIX}/nvim-${NVIM_VERSION}"
  NVIM_CONFIG="${LOCALAPPDATA_UNIX}/nvim"
  FISH_CONFIG="${HOME}/.config/fish"
  NVIM_BIN="${NVIM_HOME}/${NVIM_DIR}/bin/nvim.exe"
else
  NVIM_HOME="${XDG_DATA_HOME}/nvim-${NVIM_VERSION}"
  NVIM_CONFIG="${XDG_CONFIG_HOME}/nvim"
  FISH_CONFIG="${XDG_CONFIG_HOME}/fish"
  NVIM_BIN="${NVIM_HOME}/${NVIM_DIR}/bin/nvim"
fi

log_info "Detected OS: ${OS_ID}"
log_info "Detected architecture: ${ARCH_ID}"

if [ ! -d "${REPO_NVIM}" ]; then
  log_error "Repository Neovim config directory not found: ${REPO_NVIM}"
  exit 1
fi

if [ ! -d "${REPO_FISH}" ]; then
  log_warn "Repository fish config directory not found: ${REPO_FISH}"
fi

install_fish || true
install_neovim

make_link "${REPO_NVIM}" "${NVIM_CONFIG}"

if [ -d "${REPO_FISH}" ]; then
  if command -v fish >/dev/null 2>&1; then
    make_link "${REPO_FISH}" "${FISH_CONFIG}"

    if [ -f "${FISH_CONFIG}/config.fish" ]; then
      fish -c "source '${FISH_CONFIG}/config.fish'"
    else
      log_warn "${FISH_CONFIG}/config.fish not found. Skipping source."
    fi
  else
    log_warn "fish command not found. Skipping fish config link."
  fi
fi

log_info "Neovim binary: ${NVIM_BIN}"
echo "[SUCCESS] Initialization complete."
