#!/usr/bin/env bash

# Set project directory
PROJECT_DIR=~/dev

# Find directories (1 level deep) and choose with fzf
cd "$PROJECT_DIR" || exit 1
SESSION_NAME=$(find . -maxdepth 1 -type d -not -path '.' | sed 's|^\./||' | fzf)

# Exit if nothing was selected
[ -z "$SESSION_NAME" ] && exit 0

# Check if the session exists
if tmux has-session -t="$SESSION_NAME" 2>/dev/null; then
  tmux attach-session -t "$SESSION_NAME"
else
  tmux new-session -s "$SESSION_NAME" -c "$PROJECT_DIR/$SESSION_NAME"
fi
