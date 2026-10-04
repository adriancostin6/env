_SCRIPT="$(basename "${BASH_SOURCE[-1]:-$0}")"
LOG_COMPONENT="${LOG_COMPONENT:-$_SCRIPT}"
LOG_FILE="${LOG_FILE:-}"
_log() {
  local caller="$LOG_COMPONENT"
  local severity="$1"
  local msg="$2"

  local padding=""
  case $severity in 
    INFO | WARN)
      padding=" "
      ;;
  esac

  local time="$(date '+%Y-%m-%d %H:%M:%S')"
  if [ -n "$LOG_FILE" ]; then
      printf '%s [%s] %s %s: %s\n' \
        "$time"                    \
        "$severity"                \
        "$padding"                 \
        "$caller"                  \
        "$msg"                     \
        | tee -a "$LOG_FILE"
  else
      printf '%s [%s] %s %s: %s\n' \
        "$time"                    \
        "$severity"                \
        "$padding"                 \
        "$caller"                  \
        "$msg"
  fi
}


log() {
  local msg="$1"

  _log "INFO" "$msg"
}
wrn() {
  local msg="$1"

  _log "WARN" "$msg"
}
warn() {
  wrn "$@"
}
err() {
  local msg="$1"

  _log "ERROR" "$msg"
}
die() {
  local msg="$1"
  local code="${2:-1}"

  _log "FATAL" "$msg"
  exit $code
}
dbg() {
  local msg="$1"

  [ -n "$LOG_DEBUG" ] && _log "DEBUG" "$msg"
}

logger_set_log_component() {
  LOG_COMPONENT="$1"
}
logger_reset_log_component() {
  LOG_COMPONENT=""
}

logger_set_log_file() {
  LOG_FILE="$1"
}
logger_reset_log_file() {
  LOG_FILE=""
}

logger_set_debug() {
  LOG_DEBUG=1
}
logger_reset_debug() {
  unset LOG_DEBUG
}
