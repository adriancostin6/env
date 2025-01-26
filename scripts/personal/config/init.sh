shopt -s globstar

files=($HOME/env/scripts/personal/config/**/*.sh)
for file in "${files[@]}"; do
	echo $file
	if [ "$file" = "$HOME/env/scripts/personal/config/init.sh" ]; then
        echo "$HOME/env/scripts/personal/config/init.sh"
		continue
	fi
    echo "fuck"
	source "$file"
done

shopt -u globstar
