#!/bin/bash

DOWNLOAD_DIR="$HOME/Downloads"

# Define file categories
declare -A FILE_TYPES=(
    ["Documents"]="pdf doc docx txt xls xlsx ppt pptx"
    ["Images"]="jpg jpeg png gif bmp svg webp"
    ["Videos"]="mp4 mkv avi mov wmv"
    ["Music"]="mp3 wav flac ogg aac"
    ["Archives"]="zip rar tar gz 7z bz2"
    ["Binaries"]="sh py pl exe appimage zst"
    ["Others"]=""
)

# Create directories if they don't exist
for category in "${!FILE_TYPES[@]}"; do
    mkdir -p "$DOWNLOAD_DIR/$category"
done

# Move files into corresponding directories
for category in "${!FILE_TYPES[@]}"; do
    for ext in ${FILE_TYPES[$category]}; do
        mv "$DOWNLOAD_DIR"/*."$ext" "$DOWNLOAD_DIR/$category" 2>/dev/null
    done
done

# Move any remaining files into 'Others' directory
find "$DOWNLOAD_DIR" -maxdepth 1 -type f -exec mv {} "$DOWNLOAD_DIR/Others/" \;

echo "Downloads folder organized!"
