#!/bin/bash

check_prerequisites() {
  local missing=()
  for cmd in wpctl; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if (( ${#missing[@]} > 0 )); then
    echo "Error: Missing required command(s): ${missing[*]}" >&2
    exit 1
  fi
}

get_volume_info() {
    output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    volume=$(echo "$output" | awk '{print $2}')
    muted=$(echo "$output" | grep -q "\[MUTED\]" && echo true || echo false)
    echo "$volume $muted"
}

set_volume() {
    new_volume="$1"
    [[ $(echo "$new_volume < 0.0" | bc -l) -eq 1 ]] && new_volume=0.0
    [[ $(echo "$new_volume > 1.0" | bc -l) -eq 1 ]] && new_volume=1.0
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$new_volume" > /dev/null 2>&1
}

toggle_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle > /dev/null 2>&1
}

main() {
    check_prerequisites
    read volume muted <<<"$(get_volume_info)"
    percent=$(printf "%.0f" "$(echo "$volume * 100" | bc -l)")

    case "$1" in
        click-left)
            toggle_mute
            sleep 0.1
            ;;
        scroll-up)
            set_volume "$(echo "$volume + 0.05" | bc -l)"
            sleep 0.1
            ;;
        scroll-down)
            set_volume "$(echo "$volume - 0.05" | bc -l)"
            sleep 0.1
            ;;
    esac

    read volume muted <<<"$(get_volume_info)"
    percent=$(printf "%.0f" "$(echo "$volume * 100" | bc -l)")

    volume_high=$'\uF057E'
    volume_low=$'\uF057F'
    volume_medium=$'\uF0580'
    volume_mute=$'\uF075F'
    volume_off=$'\uF0581'

    if [[ "$muted" == "true" ]]; then
        icon="$volume_mute"
        class="muted"
        tooltip="Volume: ${percent}% [MUTED]"
    elif [[ "$volume" == "0.0" ]]; then
        icon="$volume_off"
        class="muted"
        tooltip="Volume: 0%"
    elif (( $(echo "$volume <= 0.25" | bc -l) )); then
        icon="$volume_low"
        class="volume"
        tooltip="Volume: ${percent}%"
    elif (( $(echo "$volume <= 0.5" | bc -l) )); then
        icon="$volume_medium"
        class="volume"
        tooltip="Volume: ${percent}%"
    else
        icon="$volume_high"
        class="volume"
        tooltip="Volume: ${percent}%"
    fi

    echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
}

main "$@"

