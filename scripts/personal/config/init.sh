shopt -s globstar

files=($HOME/env/scripts/personal/config/**/*.sh)
for file in "${files[@]}"; do
    if [ "$file" = "$HOME/env/scripts/personal/config/init.sh" ]; then
        continue
    fi
    source "$file"
done

shopt -u globstar
