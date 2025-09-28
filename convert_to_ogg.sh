#!/bin/bash

# Script to convert all WAV files in /home/neo/Music/ForVS/ to OGG format
# Output will be saved to /home/neo/Music/ForVS_OGG/

INPUT_DIR="/home/neo/Music/ForVS"
OUTPUT_DIR="/home/neo/Music/ForVS_OGG"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Counter for tracking progress
total_files=0
converted_files=0

# Count total WAV files first
echo "Counting WAV files..."
while IFS= read -r -d '' file; do
    ((total_files++))
done < <(find "$INPUT_DIR" -name "*.wav" -type f -print0)

echo "Found $total_files WAV files to convert"
echo "Starting conversion..."

# Convert all WAV files to OGG
while IFS= read -r -d '' file; do
    # Get relative path from input directory
    rel_path="${file#$INPUT_DIR/}"
    
    # Create output path with .ogg extension
    output_file="$OUTPUT_DIR/${rel_path%.wav}.ogg"
    
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    
    # Convert using ffmpeg
    echo "Converting: $rel_path"
    if ffmpeg -i "$file" -c:a libvorbis -q:a 5 "$output_file" -y -loglevel error; then
        ((converted_files++))
        echo "✓ Converted: $rel_path"
    else
        echo "✗ Failed to convert: $rel_path"
    fi
    
    # Show progress
    echo "Progress: $converted_files/$total_files"
    echo "---"
    
done < <(find "$INPUT_DIR" -name "*.wav" -type f -print0)

echo "Conversion complete!"
echo "Successfully converted: $converted_files/$total_files files"
echo "Output directory: $OUTPUT_DIR"
