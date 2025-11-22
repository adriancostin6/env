source ./env.sh

if [ -f "$ENV_RUST_INSTALL_LOCK" ]; then
  rustup self uninstall
  rm -f $ENV_RUST_INSTALL_LOCK
fi
