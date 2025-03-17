shopt -s globstar

source ./sanity.sh
source_rglob **/*.sh

shopt -u globstar
