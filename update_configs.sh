#!/usr/bin/env fish

# Config Management Script for neobit Vintage Server
# This script manages config files based on collect_configs.json
#
# Features:
# - Clears the local configs directory
# - Reads configuration from collect_configs.json
# - Copies config files from Vintage Story ModConfig directory
# - Modifies values based on the JSON configuration
# - Supports nested JSON structures (e.g., Thirst.MaxThirst)
#
# Usage: ./update_configs.sh

set CONFIG_JSON "/home/neo/Repositories/neobitVintageServer/collect_configs.json"
set VS_CONFIG_DIR "/home/neo/.var/app/at.vintagestory.VintageStory/config/VintagestoryData/ModConfig"
set CONFIGS_DIR "/home/neo/Repositories/neobitVintageServer/configs"

echo "=== neobit Vintage Server Config Manager ==="
echo "Config JSON: $CONFIG_JSON"
echo "VS Config Source: $VS_CONFIG_DIR"
echo "Local Configs Dir: $CONFIGS_DIR"
echo ""

# Check if config JSON exists
if not test -f "$CONFIG_JSON"
    echo "❌ Error: Config JSON not found: $CONFIG_JSON"
    exit 1
end

# Check if VS config directory exists
if not test -d "$VS_CONFIG_DIR"
    echo "❌ Error: Vintage Story config directory not found: $VS_CONFIG_DIR"
    echo "Please ensure Vintage Story is installed and the path is correct."
    exit 1
end

# Clear configs directory
echo "🗑️  Clearing configs directory..."
if test -d "$CONFIGS_DIR"
    rm -rf "$CONFIGS_DIR"
    echo "✅ Configs directory cleared"
else
    echo "ℹ️  Configs directory doesn't exist, will create it"
end

# Create configs directory
mkdir -p "$CONFIGS_DIR"
if test $status -ne 0
    echo "❌ Failed to create configs directory"
    exit 1
end

# Read and parse config JSON
echo "📖 Reading config JSON..."
set CONFIG_DATA (cat "$CONFIG_JSON" | jq -r '.configs[] | @base64')
if test $status -ne 0
    echo "❌ Failed to parse config JSON. Make sure jq is installed."
    exit 1
end

# Process each config entry
for config_entry in $CONFIG_DATA
    # Decode base64 config entry
    set config_json (echo $config_entry | base64 -d)
    set filename (echo $config_json | jq -r '.file')
    set variables (echo $config_json | jq -r '.variables | to_entries[] | @base64')
    
    echo ""
    echo "📁 Processing config file: $filename"
    
    # Source and destination paths
    set source_file "$VS_CONFIG_DIR/$filename"
    set dest_file "$CONFIGS_DIR/$filename"
    
    # Check if source file exists
    if not test -f "$source_file"
        echo "⚠️  Warning: Source config file not found: $source_file"
        echo "   Skipping this config file"
        continue
    end
    
    # Copy file to configs directory
    echo "📋 Copying $filename to configs directory..."
    # Create subdirectories if needed (e.g., for Firestarter/ files)
    set dest_dir (dirname "$dest_file")
    mkdir -p "$dest_dir"
    cp "$source_file" "$dest_file"
    if test $status -ne 0
        echo "❌ Failed to copy $filename"
        continue
    end
    echo "✅ Copied $filename successfully"
    
    # Modify values based on config
    echo "🔧 Modifying values in $filename..."
    for var_entry in $variables
        set var_json (echo $var_entry | base64 -d)
        set var_name (echo $var_json | jq -r '.key')
        set var_value (echo $var_json | jq -r '.value')
        
        echo "   Setting $var_name = $var_value"
        
        # Use appropriate tool based on file extension
        set temp_file (mktemp)
        set file_ext (echo "$dest_file" | sed 's/.*\.//')
        
        if test "$file_ext" = "json"
            # Use jq for JSON files
            # Handle nested paths (e.g., Advanced.IncreaseMarkDirtyThreshold)
            if string match -q "*.*" "$var_name"
                # Use jq dot notation for nested paths
                jq --argjson value "$var_value" ".$var_name = \$value" "$dest_file" > "$temp_file"
            else
                # Try to update in Thirst section first, fallback to root level
                jq --arg key "$var_name" --argjson value "$var_value" '.Thirst[$key] = $value' "$dest_file" > "$temp_file"
                if test $status -ne 0
                    # If Thirst section doesn't exist or key not found, try root level
                    jq --arg key "$var_name" --argjson value "$var_value" '.[$key] = $value' "$dest_file" > "$temp_file"
                end
            end
        else if test "$file_ext" = "yaml" -o "$file_ext" = "yml"
            # Use yq for YAML files (if available) or sed as fallback
            if command -v yq > /dev/null
                # Use yq for YAML modification
                yq eval ".$var_name = $var_value" "$dest_file" > "$temp_file"
            else
                # Fallback to sed for simple YAML modifications
                # This is a basic implementation - may need adjustment for complex YAML
                sed "s/^$var_name:.*/$var_name: $var_value/" "$dest_file" > "$temp_file"
                if test $status -ne 0
                    # If key doesn't exist, add it at the end
                    echo "$var_name: $var_value" >> "$temp_file"
                end
            end
        else
            echo "   ⚠️  Unsupported file type: $file_ext"
            rm -f "$temp_file"
            continue
        end
        if test $status -eq 0
            mv "$temp_file" "$dest_file"
            echo "   ✅ Updated $var_name"
        else
            echo "   ❌ Failed to update $var_name"
            rm -f "$temp_file"
        end
    end
    echo "✅ Finished modifying $filename"
end

echo ""
echo "🎉 Config management completed successfully!"
echo "📁 Modified configs are available in: $CONFIGS_DIR"
echo ""
echo "📋 Summary of processed configs:"
for config_entry in $CONFIG_DATA
    set config_json (echo $config_entry | base64 -d)
    set filename (echo $config_json | jq -r '.file')
    set dest_file "$CONFIGS_DIR/$filename"
    if test -f "$dest_file"
        echo "   ✅ $filename"
    else
        echo "   ❌ $filename (failed)"
    end
end
