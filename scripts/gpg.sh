function setup_gpg {
  printf "Setting up GPG."
  local conf="$HOME/.gnupg"
  #echo "use-agent" >> "$conf/gpg.conf"
  #echo "pinentry-mode loopback" >> "$conf/gpg.conf"
  echo "allow-loopback-pinentry" >> "$conf/gpg-agent.conf"
  echo RELOADAGENT | gpg-connect-agent
}
function setup_keys {
  if [ $# -ne 2 ];then
    printf "Usage: setup_keys.sh private public\n"
    printf "Helper to setup GPG keys.\n"
    printf "  private: private key location\n"
    printf "  public: public key location\n"
    printf "Tip: Set up private key in ~/.conf-secret.gpg"
    return 1
  fi

  printf "Importing GPG keys.\n"
  if [ ! -f "$1" ]; then
    printf "Private key $1 not found.\n"
    return 1
  fi

  gpg --import "$1"
  gpg --import "$2"
}

function encrypt_directory {
  if [ $# -ne 2 ]; then
    printf "Cannot encrypt directory.\n"
    printf "Usage: encrypt_directory directory user.\n"
    return 1
  fi

  local directory="$1"
  local recipient="$2"

  cd "$1"

  local files=(*)
  local archive_name="$(basename $PWD).tar.gz"

  tar czf "$archive_name" *
  for file in "${files[@]}"
  do
      rm -rf $file
  done

  gpg --output "$archive_name.gpg" --encrypt -r "$recipient" "$archive_name"
  rm -f "$archive_name"

  cd -
}

function decrypt_directory {
  if [ $# -ne 2 ]; then
      printf "No directory provided.\n"
      printf "Usage: encrypt_directory directory passphrase-file.\n"
      return 1
    fi

  local directory="$1"
  cd "$directory"

  local archive_name="$(basename $PWD).tar.gz"
  local path="$directory/$archive_name.gnupg"
  local pfile="$2"

  gpg \
      --pinentry-mode loopback                  \
      --passphrase-file "$pfile"                \
      --output "$archive_name"                  \
      --decrypt "$archive_name.gpg" &&          \
  tar xvf "$archive_name" &&                    \
  rm -f "$archive_name.gpg" "$archive_name" &&  \
  git update-index --assume-unchanged "$archive_name.gpg"

  cd -
}
