cd() {
  command -v z &>/dev/null || builtin cd "$@" || return k
  z "$@"
}
