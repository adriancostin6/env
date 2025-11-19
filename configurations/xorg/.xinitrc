# todo: extract these as status bar module
function battery {
  local charge="$(cat /sys/class/power_supply/BAT1/capacity)%" 
  local status="$(cat /sys/class/power_supply/BAT1/status)"
  echo "$charge $status"
}
function date_time {
  local time=$(date "+%F %R")
  echo "$time"
}

while true
do
  component_time="[ $(date_time) ]"
  component_battery="[ $(battery) ]"

  status=""
  status="$status$component_time "
  status="$status$component_battery"

  xsetroot -name "$status"

  sleep 1m
done &

PATH="$HOME/.local/bin:$PATH"
xrandr --size 1920x1080
exec dwm
