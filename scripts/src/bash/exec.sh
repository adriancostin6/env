exec_if() {
  local check=$1
  command -v "$check" &>/dev/null && eval "$("$@")"
}
