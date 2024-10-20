exec_if() {
  local check=$1
  command -v "$check" &>/dev/null && eval "$("$@")"
}
exec_if_not() {
  local check=$1
  command -v "$check" &>/dev/null || eval "$("$@")"
}
