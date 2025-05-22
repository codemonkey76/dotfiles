#!/bin/bash

STATE_FILE="/tmp/wg-current"

check_prerequisites() {
  local missing=()
  for cmd in nmcli; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if (( ${#missing[@]} > 0 )); then
    echo "Error: Missing required command(s): ${missing[*]}" >&2
    exit 1
  fi
}


get_wireguard_connections() {
    nmcli -g NAME,TYPE connection show | grep ':wireguard' | cut -d':' -f1 | sort
}

read_state() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "$1"
    fi
}

write_state() {
    echo "$1" > "$STATE_FILE"
}

is_active() {
    nmcli connection show --active | grep -q "$1"
}

toggle_connection() {
    if is_active "$1"; then
        nmcli connection down "$1" > /dev/null
        echo "{\"text\": \"$1\", \"class\": \"inactive\"}"
    else
        nmcli connection up "$1" > /dev/null
        echo "{\"text\": \"$1\", \"class\": \"active\"}"
    fi
}

status_output() {
    if is_active "$1"; then
        echo "{\"text\": \"🛡️  $1\", \"class\": \"active\"}"
    else
        echo "{\"text\": \"🚫  $1\", \"class\": \"inactive\"}"
    fi
}

rotate_current() {
    local current="$1"
    local reverse="$2"
    shift 2
    local list=("$@")
    local index=0

    for i in "${!list[@]}"; do
        if [[ "${list[i]}" == "$current" ]]; then
            index="$i"
            break
        fi
    done

    if [[ "$reverse" == true ]]; then
        ((index--))
        ((index < 0)) && index=$((${#list[@]} - 1))
    else
        ((index++))
        ((index >= ${#list[@]})) && index=0
    fi

    echo "${list[index]}"
}

main() {
    check_prerequisites
    mapfile -t conn_list < <(get_wireguard_connections)

    if [[ "${#conn_list[@]}" -eq 0 ]]; then
        echo '{"text": "No VPNs", "class": "inactive"}'
        exit 0
    fi

    current=$(read_state "${conn_list[0]}")

    case "$1" in
        next)
            next_conn=$(rotate_current "$current" false "${conn_list[@]}")
            write_state "$next_conn"
            status_output "$next_conn"
            ;;
        previous)
            next_conn=$(rotate_current "$current" true "${conn_list[@]}")
            write_state "$next_conn"
            status_output "$next_conn"
            ;;
        --status)
            status_output "$current"
            ;;
        *)
            toggle_connection "$current"
            ;;
    esac
}

main "$@"

