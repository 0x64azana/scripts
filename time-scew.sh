#!/bin/bash
# ----------------------------------------------------------
# Script Name:     time-scew.sh
# Description:     Short description of what the script does.
# Author:          0x64azana
# Created:         2025-10-XX
# Version:         1.0
# Usage:           time-scew.sh <DC-IP>
# Requirements:	   LDAP/389 , systemd-timesyncd
# ----------------------------------------------------------

sudo systemctl stop systemd-timesyncd

if [ -z "$1" ]; then
    echo "Usage: $0 <DC-IP>"
    exit 1
fi

DC_IP="$1"

# Get LDAP UTC time
ldap_time=$(ldapsearch -x -H ldap://$DC_IP -s base currentTime 2>/dev/null \
    | grep "^currentTime" \
    | awk '{print $2}' \
    | tr -d 'Z')

if [ -z "$ldap_time" ]; then
    echo "[!] Could not retrieve LDAP time. Check LDAP/port 389."
    exit 1
fi

# Format: YYYYMMDDHHMMSS.0
# Convert to: YYYY-MM-DD HH:MM:SS
formatted_time=$(echo "$ldap_time" | sed -E 's/^(.{4})(.{2})(.{2})(.{2})(.{2})(.{2}).*/\1-\2-\3 \4:\5:\6/')

echo "[+] DC LDAP time (UTC): $formatted_time"

# Set system time in UTC
sudo date -u -s "$formatted_time"

echo "[+] System time synchronized."
date

