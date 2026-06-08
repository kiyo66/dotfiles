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
