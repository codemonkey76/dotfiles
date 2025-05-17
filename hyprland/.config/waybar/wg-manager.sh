#!/usr/bin/env bash

STATE="/tmp/wg-current"
VPN_LIST=$(nmcli -g NAME,TYPE connection show | grep '^.*:wireguard$' | cut -d: -f1 | sort)
if [[ -z "$VPN_LIST" ]]; then
    echo "󰌾 No WireGuard connections"
    exit 1
fi
VPN_ARRAY=($VPN_LIST)
CURRENT=$(cat "$STATE" 2>/dev/null || echo "${VPN_ARRAY[0]}")

# Rotate selection
if [[ $1 == "next" ]]; then
    index=$(printf "%s\n" "${VPN_ARRAY[@]}" | grep -nx "$CURRENT" | cut -d: -f1)
    index=$(( (index % ${#VPN_ARRAY[@]}) ))
    CURRENT="${VPN_ARRAY[$index]}"
    echo "$CURRENT" > "$STATE"
    exit 0
fi

# Toggle VPN
STATUS=$(nmcli connection show --active | grep -w "$CURRENT")
if [[ -n "$STATUS" ]]; then
    nmcli connection down "$CURRENT"
    echo "󰌾 $CURRENT"
else
    nmcli connection up "$CURRENT"
    echo "󰘚 $CURRENT"
fi
