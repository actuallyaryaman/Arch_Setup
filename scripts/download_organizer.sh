#!/bin/bash

DOWNLOAD_DIR="$HOME/Downloads"
cd "$DOWNLOAD_DIR" || exit

# Create misc folder if it doesn't exist
mkdir -p misc

# Scan all top-level files in Downloads
find . -maxdepth 1 -type f | while read -r file; do
    filename="${file##*/}"
    # If file has no extension
    if [[ "$filename" != *.* ]]; then
        mv "$filename" misc/
        continue
    fi
    # Extract extension
    ext="${filename##*.}"
    # If the extension is the same as the filename (no extension)
    if [[ "$ext" == "$filename" ]]; then
        mv "$filename" misc/
        continue
    fi
    # Create folder for extension if it doesn't exist
    mkdir -p "$ext"
    # Move file to the respective extension folder
    mv "$filename" "$ext/"
done
