#!/usr/bin/env bash
echo "$(date): wrote config" >>/tmp/gen-config.log

### 🔧 Hyprland dynamic include generation
HOSTNAME="$(hostnamectl hostname)"
HYP_CONF_DIR="$HOME/.config/hypr/conf/$HOSTNAME"
HYP_TARGET="$HOME/.config/hypr/conf/host-specific.conf"

echo "[*] Generating Hyprland config for host: $HOSTNAME"
>"$HYP_TARGET" # Truncate the target file

for file in "$HYP_CONF_DIR"/*.conf; do
  if [ -f "$file" ]; then
    echo "source = $file" >>"$HYP_TARGET"
  fi
done

### 🔧 Waybar config merge
WAYBAR_DIR="$HOME/.config/waybar"
WAYBAR_SHARED="$WAYBAR_DIR/config-shared.jsonc"
WAYBAR_HOST="$WAYBAR_DIR/config-$HOSTNAME.jsonc"
WAYBAR_TARGET="$WAYBAR_DIR/config.jsonc"

echo "[*] Generating Waybar config for host: $HOSTNAME"
if [[ ! -f "$WAYBAR_SHARED" ]]; then
  echo "❌ Missing shared config: $WAYBAR_SHARED"
  exit 1
fi

if [[ ! -f "$WAYBAR_HOST" ]]; then
  echo "❌ Missing host config for $HOSTNAME: $WAYBAR_HOST"
  exit 1
fi

echo "// Generated at: $(date)" >"$WAYBAR_TARGET"

jq -s '.[0] * .[1]' \
  <(npx strip-json-comments "$WAYBAR_SHARED") \
  <(npx strip-json-comments "$WAYBAR_HOST") \
  >>"$WAYBAR_TARGET"

echo "✅ Regenerated: $WAYBAR_TARGET"
