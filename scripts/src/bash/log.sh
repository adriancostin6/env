LOG_COMPONENT=""
_log() {
  local caller="$LOG_COMPONENT"
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

  _log "$LOG_COMPONENT" "INFO" "$msg"
}
wrn() {
  local msg="$1"

  _log "$LOG_COMPONENT" "WARN" "$msg"
}
err() {
  local msg="$1"

  _log "$LOG_COMPONENT" "ERROR" "$msg"
}
die() {
  local msg="$1"

  _log "$LOG_COMPONENT" "FATAL" "$msg"
  exit 1
}
dbg() {
  local msg="$1"

  [ -n "$LOG_DEBUG" ] && _log "$LOG_COMPONENT" "DEBUG" "$msg"
}

logger_set_log_component() {
  LOG_COMPONENT="$1"
}
logger_reset_log_component() {
  LOG_COMPONENT=""
}
