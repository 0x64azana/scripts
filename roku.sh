#!/bin/bash

# Set your Roku device's IP address
ROKU_IP="192.168.1.39"
ROKU_PORT=8060
ROKU_URL="http://${ROKU_IP}:${ROKU_PORT}"

# Send a keypress
send_key() {
    local KEY=$1
    curl -s -X POST "${ROKU_URL}/keypress/${KEY}" > /dev/null
}

# Clean up terminal on exit
cleanup() {
    stty sane
    echo -e "\nExiting Roku Remote."
    exit
}

# Print help
cat <<EOF
Roku Remote started.

- Use arrow keys
- Enter/Space (Select)
- Backspace (Back)
- Esc (Home)
- Ctrl+C to quit.
EOF

# Trap exit
trap cleanup INT TERM EXIT

# Turn off echo & enable raw mode
stty -echo -icanon

while true; do
    # Read 1 byte with timeout
    if IFS= read -rsn1 -t 0.1 key; then
        if [[ $key == $'\e' ]]; then
            # Read additional bytes for arrows or esc
            if IFS= read -rsn2 -t 0.1 rest; then
                case "$rest" in
                    '[A') send_key "Up" ;;
                    '[B') send_key "Down" ;;
                    '[C') send_key "Right" ;;
                    '[D') send_key "Left" ;;
                    *)    send_key "Home" ;;  # Unknown sequence after Esc
                esac
            else
                send_key "Home"   # Esc key alone
            fi
        elif [[ $key == $'\x7f' ]]; then
            send_key "Back"      # Backspace
        elif [[ $key == $'\n' || $key == " " ]]; then
            send_key "Select"    # Enter or Space
        fi
    fi
done

