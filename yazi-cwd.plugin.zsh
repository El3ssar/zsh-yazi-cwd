# yazi-cwd: open yazi and cd into the last dir on exit
# Options you may override in ~/.zshrc:
#   YAZI_BIN=yazi
#   YAZI_FUNC=y

: "${YAZI_BIN:=$(command -v yazi)}"
: "${YAZI_FUNC:=y}"

# Core implementation (+ zoxide-aware target resolution)
_yazi_cwd_impl() {
  local ybin="$YAZI_BIN" tmp cwd

  # In case it does not exist
  if ! command -v -- "$ybin" >/dev/null 2>&1; then
    print -u2 "yazi-cwd: '$ybin' not found in PATH"
    return 127
  fi

  # ---------- zoxide/dir resolution of $1 (only if first arg isn't an option) ----------
  if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then
    if [ -d "$1" ]; then
      : # keep as-is
    elif command -v zoxide >/dev/null 2>&1; then
      local zi
      zi="$(zoxide query -- "$1" 2>/dev/null)" || zi=""
      if [ -n "$zi" ]; then
        set -- "$zi" "${@:2}"
      fi
    fi
  fi
  # ------------------------------------------------------------------------------------

  # mktemp (Linux/macOS)
  if ! tmp="$(mktemp -t yazi-cwd.XXXXXX 2>/dev/null)"; then
    tmp="$(mktemp /tmp/yazi-cwd.XXXXXX)" || { print -u2 "yazi-cwd: mktemp failed"; return 1; }
  fi

  # always clean up
  trap 'rm -f -- "$tmp"; trap - EXIT INT TERM' EXIT INT TERM

  "$ybin" "$@" --cwd-file="$tmp" || { local rc=$?; rm -f -- "$tmp"; trap - EXIT INT TERM; return $rc; }

  # yazi writes NUL-terminated path
  local IFS=
  if ! read -r -d $'\0' cwd < "$tmp"; then
    cwd="$(<"$tmp")"  # fallback if -d $'\0' fails
  fi

  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
}

# Expose as function name (default: y). Keep it simple & explicit.
eval "function ${YAZI_FUNC} { _yazi_cwd_impl \"\$@\" }"

# Tab completion: directories
compdef '_files -/' "${YAZI_FUNC}"

