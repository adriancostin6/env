function setup_keys {
  if [ $# -ne 2 ]; then
    printf "Usage: setup_keys.sh private public\n"
    printf "Helper to setup GPG keys.\n"
    printf "  private: private key location\n"
    printf "  public: public key location\n"
    printf "Tip: Set up private key in ~/.conf-secret"
    return 1
  fi

  printf "Importing GPG keys.\n"
  if [ ! -f "$1" ]; then
    printf "Private key $1 not found.\n"
    return 1
  fi

  local private="$1"
  local public="$2"

  gpg --verbose --import "$public"
  gpg --verbose --import "$private"
}

function encrypt_directory {
  if [ $# -ne 1 ]; then
    printf "Cannot encrypt directory.\n"
    printf "Usage: encrypt_directory directory\n"
    return 1
  fi

  local directory="$1"
  cd "$1"

  local files=(*)
  local archive_name="$(basename $PWD).tar.gz"

  tar czf "$archive_name" *
  for file in "${files[@]}"
  do
      rm -rf $file
  done

  read -r -p "Enter GPG user id" id

  gpg --verbose \
    --output "$archive_name.gpg"     \
    --encrypt -r "$id" "$archive_name" && \
  rm -f "$archive_name"

  cd -
}

function decrypt_directory {
  if [ $# -ne 1 ]; then
      printf "No directory provided.\n"
      printf "Usage: decrypt_directory directory.\n"
      return 1
    fi

  local directory="$1"
  cd "$directory"

  local archive_name="$(basename $PWD).tar.gz"

  gpg --verbose \
    --output "$archive_name"                    \
    --decrypt "$archive_name.gpg" &&            \
  tar xvf "$archive_name" &&                    \
  rm -f "$archive_name.gpg" "$archive_name" &&  \

  cd -
}

function crypt_dirs_with_func {
  local func=$1
  shift
  echo $func

  local dirs=($*) 
  for dir in "${dirs[@]}"
  do
    $func $dir
  done
}
