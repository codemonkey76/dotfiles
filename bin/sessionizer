#!/usr/bin/env bash

PROJECTS_DIR="$HOME/dev"
selected=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d | fzf)

if [[ -z "$selected" ]]; then
    exit 0
fi

session_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

tmux attach -t "$session_name"
