#!/bin/zsh

# Define Zsh history file
HISTORY_FILE="$HOME/.zhistory"

# Create a backup before modifying
cp "$HISTORY_FILE" "${HISTORY_FILE}.backup"

# Remove duplicate commands while keeping the last occurrence
awk -F ';' '{cmd=$2; if (!seen[cmd]++) print}' "$HISTORY_FILE" > "${HISTORY_FILE}.cleaned"

# Replace the original history file with the cleaned one
mv "${HISTORY_FILE}.cleaned" "$HISTORY_FILE"

# Reload history into the current session
fc -R

echo "Zsh history cleaned! Backup saved as ${HISTORY_FILE}.backup"
