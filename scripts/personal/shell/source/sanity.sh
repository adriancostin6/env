alias_or_warn() {
  command -v $2 &> /dev/null || { printf "Missing $2, cannot make alias.\n"; return; }

  local aalias="$1"
  shift

	# We use $* here because we want to specify the full string as is.
  alias "$aalias=$*"
}

execif() {
	command -v $1 &>/dev/null && eval "$("$@")"
}
