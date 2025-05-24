#!/usr/bin/env bash
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
screenshot_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshot_dir"
output_file="$screenshot_dir/screenshot_$timestamp.png"

region=$(slurp)
[ -z "$region" ] && notify-send "Screenshot cancelled" && exit 1

grim -g "$region" "$output_file"
wl-copy <"$output_file"

notify-send "Screenshot taken" "Saved to $output_file and copied to clipboard"
