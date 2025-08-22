#!/usr/bin/env bash

NVIM_VERSION="v0.11.0"
NVIM_TARBALL="nvim-linux-x86_64.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_TARBALL}"
NVIM_HOME="${HOME}/.config/nvim-${NVIM_VERSION}"
NVIM_BIN="${NVIM_HOME}/nvim-linux-x86_64/bin/nvim"
NVIM_CONFIG="${HOME}/.config/nvim"
FISH_CONFIG="${HOME}/.config/fish"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_NVIM="${SCRIPT_DIR}/nvim"
REPO_FISH="${SCRIPT_DIR}/fish"


if [ -e "${NVIM_HOME}" ] && [ ! -d "${NVIM_HOME}" ]; then
  echo "[WARN] ${NVIM_HOME} exists but is not a directory. Removing it..."
  rm -f "${NVIM_HOME}"
fi

# Installing fish
if ! command -v fish >/dev/null 2>&1; then
  echo "[INFO] fish not found. Installing..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y fish
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y fish
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y fish
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm fish
  else
    echo "[ERROR] Unsupported package manager. Please install fish manually." >&2
    exit 1
  fi
else
  echo "[INFO] fish already installed."
fi

# Installing nvim
if [ -x "${NVIM_BIN}" ]; then
  echo "[INFO] Neovim ${NVIM_VERSION} already present at ${NVIM_BIN}"
else
  echo "[INFO] Fetching Neovim ${NVIM_VERSION} tarball..."
  tmp_tar="$(mktemp -t nvim.XXXXXX.tar.gz)"
  wget -q "${NVIM_URL}" -O "${tmp_tar}"
  mkdir -p "${NVIM_HOME}"
  tar -xzf "${tmp_tar}" -C "${NVIM_HOME}"
  rm -f "${tmp_tar}"

  if [ -f "${NVIM_BIN}" ]; then
    chmod +x "${NVIM_BIN}" || true
  fi
  if [ ! -x "${NVIM_BIN}" ]; then
    echo "[ERROR] Neovim binary not found after extraction: ${NVIM_BIN}" >&2
    exit 1
  fi
  echo "[INFO] Neovim installed under ${NVIM_HOME}"
fi

make_link() {
  local target="$1"
  local link="$2"

  if [ -L "${link}" ] || [ -e "${link}" ]; then
    if [ -L "${link}" ] && [ "$(readlink -f "${link}")" = "$(readlink -f "${target}")" ]; then
      echo "[INFO] Link OK: ${link} -> ${target}"
      return 0
    fi
    echo "[INFO] Replacing existing ${link}"
    rm -f "${link}" 2>/dev/null || sudo rm -rf "${link}"
  fi

  ln -s "${target}" "${link}" 2>/dev/null || sudo ln -s "${target}" "${link}"
  echo "[INFO] Created: ${link} -> ${target}"
}

# Link for nvim
make_link "${REPO_NVIM}" "${NVIM_CONFIG}"

# Link for fish
if command -v fish >/dev/null 2>&1; then
  make_link "${REPO_FISH}" "${FISH_CONFIG}"
else
  echo "[ERROR] 'fish' command not found after install." >&2
  exit 1
fi

if [ -f "${FISH_CONFIG}/config.fish" ]; then
  fish -c "source '${FISH_CONFIG}/config.fish'"
else
  echo "[WARN] ${FISH_CONFIG}/config.fish not found. Skipping source."
fi

echo "[SUCCESS] Initialization complete."

