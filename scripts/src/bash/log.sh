_log() {
  local caller="$1"
  local severity="$2"
  local msg="$3"

  if [ -z "$caller" ]; then
    caller=$(basename "${BASH_SOURCE[-1]:-$0}")
  fi

  local padding=""
  case $severity in 
    INFO | WARN)
      padding=" "
      ;;
  esac

  printf "[$severity] $padding $(date) $caller: $msg\n"
}

log() {
  local msg="$1"
  local caller="$2"

  _log "$caller" "INFO" "$msg"
}
wrn() {
  local msg="$1"
  local caller="$2"

  _log "$caller" "WARN" "$msg"
}
err() {
  local msg="$1"
  local caller="$2"

  _log "$caller" "ERROR" "$msg"
}
die() {
  local msg="$1"
  local caller="$2"

  _log "$caller" "FATAL" "$msg"
  exit 1
}
dbg() {
  local msg="$1"
  local caller="$2"

  [ -n "$LOG_DEBUG" ] && _log "$caller" "DEBUG" "$msg"
}
