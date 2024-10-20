psme() {
  local grepper=rg
  command -v $grepper &>/dev/null || grepper=grep
  ps -aux | $grepper $(whoami)
}
