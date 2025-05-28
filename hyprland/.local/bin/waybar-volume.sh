#!/usr/bin/env bash

get_volume_info() {
  local output
  output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
  local volume
  volume=$(echo "$output" | awk '{print $2}')
  local muted=0
  if echo "$output" | grep -q '\[MUTED\]'; then
    muted=1
  fi
  echo "$volume $muted"
}

set_volume() {
  local new_volume=$1
  # Clamp between 0.0 and 1.0
  if (($(echo "$new_volume > 1.0" | bc -l))); then
    new_volume=1.0
  elif (($(echo "$new_volume < 0.0" | bc -l))); then
    new_volume=0.0
  fi
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$new_volume" >/dev/null 2>&1
}

toggle_mute() {
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle >/dev/null 2>&1
}

main() {
  local args=("$@")
  if [ "${#args[@]}" -gt 0 ]; then
    read -r volume _ <<<"$(get_volume_info)"

    case "${args[0]}" in
    click-left)
      toggle_mute
      ;;
    scroll-up)
      set_volume "$(echo "$volume + 0.05" | bc)"
      ;;
    scroll-down)
      set_volume "$(echo "$volume - 0.05" | bc)"
      ;;
    esac
    sleep 0.1
  fi

  read -r volume muted <<<"$(get_volume_info)"
  percent=$(printf "%.0f" "$(echo "$volume * 100" | bc -l)")

  volume_high="󰕾"
  volume_medium="󰖀"
  volume_low="󰕿"
  volume_mute="󰟏"
  volume_off="󰖁"

  if [ "$muted" -eq 1 ]; then
    icon="$volume_mute"
    tooltip="Volume: ${percent}% [MUTED]"
    class="muted"
  elif (($(echo "$volume == 0.0" | bc -l))); then
    icon="$volume_off"
    tooltip="Volume: ${percent}%"
    class="volume"
  elif (($(echo "$volume <= 0.25" | bc -l))); then
    icon="$volume_low"
    tooltip="Volume: ${percent}%"
    class="volume"
  elif (($(echo "$volume <= 0.5" | bc -l))); then
    icon="$volume_medium"
    tooltip="Volume: ${percent}%"
    class="volume"
  else
    icon="$volume_high"
    tooltip="Volume: ${percent}%"
    class="volume"
  fi

  jq -c -n \
    --arg text "$icon" \
    --arg tooltip "$tooltip" \
    --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class}'
}

main "$@"
