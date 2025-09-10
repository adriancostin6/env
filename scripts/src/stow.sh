function stow_pkg {
  local pkg="$1"
  local dest="$2"

  stow --target="$dest" --stow "$pkg"
}

function unstow_pkg {
  local pkg="$1"
  local dest="$2"

  stow --target="$dest" --delete "$pkg"
}
