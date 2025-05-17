#!/usr/bin/env bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh 2>/dev/null)

# Save env for apps/terminals to re-source later
env > "$XDG_RUNTIME_DIR/hypr-session.env"
