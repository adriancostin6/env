function set_brightness {
    if [ $# -ne 1 ]; then
        printf "usage: set_brightness val\n"
        return 1
    fi

    local val="$1"
    if [ $val -lt 0 ] || [ $val -gt 255 ]; then
        printf "0 <= val <= 255\n"
        return 1
    fi

    local backlights=(/sys/class/backlight/*) 
    local first="${backlights[0]}"
    echo "$val" | sudo tee "$first/brightness" > /dev/null
}
