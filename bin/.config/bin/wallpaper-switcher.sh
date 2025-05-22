#!/bin/bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LANDSCAPE_INDEX="$HOME/.cache/hyprpaper_index_landscape"
PORTRAIT_INDEX="$HOME/.cache/hyprpaper_index_portrait"
RE_EXTENSIONS="(?i)\.(jpg|jpeg|png|webp|jxl)$"

landscape_images=()
portrait_images=()

check_prerequisites() {
  local missing=()
  for cmd in jq hyprctl magick identify sha256sum; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if (( ${#missing[@]} > 0 )); then
    echo "Error: Missing required command(s): ${missing[*]}" >&2
    exit 1
  fi
}

classify_wallpapers() {
  shopt -s nullglob globstar
  for file in "$WALLPAPER_DIR"/**/*; do
    [[ ! -f "$file" ]] && continue
    [[ ! "$file" =~ $RE_EXTENSIONS ]] && continue

    read -r width height < <(identify -format "%w %h" "$file" 2>/dev/null)
    [[ -z "$width" || -z "$height" ]] && continue

    if (( width >= height )); then
      landscape_images+=("$file")
    else
      portrait_images+=("$file")
    fi
  done
}

generate_blur_if_needed() {
  local original="$1"
  local output="$2"

  local orig_mtime cached_mtime
  orig_mtime=$(stat -c %Y "$original" 2>/dev/null) || {
    echo "Could not get mtime for $original"
    return
  }

  if [[ -f "$output" ]]; then
    cached_mtime=$(stat -c %Y "$output" 2>/dev/null || echo 0)
    if (( cached_mtime >= orig_mtime )); then
      echo "Skipping already cached: $output"
      return
    else
      echo "Cached version is stale: $output"
    fi
  else
    echo "No cached version found for: $output"
    mkdir -p "$(dirname "$output")"
  fi

  echo "Regenerating blur for: $original"
  magick "$original" -blur 0x10 -fill 'rgba(0,0,0,0.8)' -draw 'rectangle 0,0 10000,10000' "$output"
}

get_monitors() {
  jq -c '.[] | {name: .name, transform: .transform}' <<<"$(hyprctl monitors -j)"
}

get_monitor_orientation() {
  local transform="$1"
  if (( transform % 2 == 0 )); then
    echo "landscape"
  else
    echo "portrait"
  fi
}

get_index() {
  local path="$1"
  [[ -f "$path" ]] && cat "$path" || echo 0
}

save_index() {
  local path="$1" value="$2"
  echo "$value" > "$path"
}

select_wallpaper() {
  local orientation="$1"
  local -n images_ref="$2"  # pass array name as reference
  local index_file="$3"
  
  local count="${#images_ref[@]}"
  [[ "$count" -eq 0 ]] && return 1

  local index
  index=$(get_index "$index_file")
  index=$(( index % count ))

  save_index "$index_file" $((index + 1))
  echo "${images_ref[$index]}"
}

set_wallpaper_for_monitor() {
  local monitor="$1"
  local wallpaper="$2"

  echo "Setting wallpaper for $monitor: $wallpaper"
  hyprctl hyprpaper preload "$wallpaper"
  hyprctl hyprpaper wallpaper "$monitor,$wallpaper"

  # Generate blurred version
  hash=$(echo -n "$wallpaper" | sha256sum | cut -d' ' -f1)
  blurred="/tmp/hyprlock-cache/${hash}.png"
  generate_blur_if_needed "$wallpaper" "$blurred"

  # Symlink for hyprlock
  mkdir -p /tmp/hyprlock
  symlink_path="/tmp/hyprlock/${monitor}.png"
  rm -f "$symlink_path"
  ln -s "$blurred" "$symlink_path"
}


# --- Main ---
check_prerequisites
classify_wallpapers

while IDS= read -r monitor_json; do
    name=$(jq -r '.name' <<< "$monitor_json")
    transform=$(jq -r '.transform' <<< "$monitor_json")
    orientation=$(get_monitor_orientation "$transform")

    case "$orientation" in
        landscape)
            selected=$(select_wallpaper "$orientation" landscape_images "$LANDSCAPE_INDEX")
            ;;
        portrait)
            selected=$(select_wallpaper "$orientation" portrait_images "$PORTRAIT_INDEX")
            ;;
    esac

    if [[ -n "${selected:-}" ]]; then
        set_wallpaper_for_monitor "$name" "$selected"
    fi

done < <(get_monitors)


