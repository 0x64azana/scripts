#!/bin/bash
# ----------------------------------------------------------
# Script Name:     url-to-usernamer.sh
# Description:     Combines CeWL and usernamer to speed up the username enumeration process.
# Author:          0x64azana
# Created:         2025-02-25
# Version:         1.0
# Usage:           url-to-usernamer.sh <URL>
# Requirements:    cewl, usernamer
# ----------------------------------------------------------


#####################
#	Vars
#####################
TARGET="$1"
TMP_WORDS=$(mktemp)
TMP_NAMES=$(mktemp)
TMP_USERNAMES=$(mktemp)
OUTPUT="usernames.txt"


if [ -z "$TARGET" ]; then
  echo "[!] Usage: $0 <url>"
  exit 1
fi


#####################
#	Pulls random words and filters them
#####################
echo "[*] Crawling $TARGET with cewl..."
cewl -d 3 "$TARGET" -w "$TMP_WORDS"

echo "[*] Filtering for capitalized words..."
grep -E '^[A-Z][a-z]{2,}$' "$TMP_WORDS" > "$TMP_NAMES.tmp"

echo "[*] Building likely full names..."
awk '
  NR==1 { prev=$0; next }
  {
    if (prev ~ /^[A-Z][a-z]+$/ && $0 ~ /^[A-Z][a-z]+$/) {
      print prev " " $0
    }
    prev=$0
  }
' "$TMP_NAMES.tmp" > "$TMP_NAMES"


#####################
#	Organizes the output into several different naming formats
#####################
echo "[*] Generating usernames with usernamer..."
usernamer -f "$TMP_NAMES" > "$TMP_USERNAMES"

# Write both original and lowercase versions to final output
cat "$TMP_USERNAMES" > "$OUTPUT"
tr '[:upper:]' '[:lower:]' < "$TMP_USERNAMES" >> "$OUTPUT"

# Remove duplicates
sort -u "$OUTPUT" -o "$OUTPUT"

echo "[+] Done. Output saved to $OUTPUT"


#####################
#	Clean up
#####################
rm -f "$TMP_WORDS" "$TMP_NAMES" "$TMP_NAMES.tmp" "$TMP_USERNAMES"
