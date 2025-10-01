#!/usr/bin/env fish

# N.E.S. Music Mod Pack and Install Script
# This script removes old mod, packs new mod, and installs it to Vintage Story

set MOD_NAME "nesmusic"
set MOD_VERSION "1.0.0"
set MOD_DIR "/home/neo/Repositories/neobitVintageServer/nesmusic"
set VS_MODS_DIR "/home/neo/.var/app/at.vintagestory.VintageStory/config/VintagestoryData/Mods"
set ZIP_NAME "$MOD_NAME"_"$MOD_VERSION".zip

echo "=== N.E.S. Music Mod Packer ==="
echo "Mod: $MOD_NAME v$MOD_VERSION"
echo "Source: $MOD_DIR"
echo "Target: $VS_MODS_DIR"
echo ""

# Check if mod directory exists
if not test -d "$MOD_DIR"
    echo "❌ Error: Mod directory not found: $MOD_DIR"
    exit 1
end

# Check if Vintage Story mods directory exists
if not test -d "$VS_MODS_DIR"
    echo "❌ Error: Vintage Story mods directory not found: $VS_MODS_DIR"
    echo "Please ensure Vintage Story is installed and the path is correct."
    exit 1
end

# Remove old mod if it exists
set OLD_MOD_PATH "$VS_MODS_DIR/$ZIP_NAME"
if test -f "$OLD_MOD_PATH"
    echo "🗑️  Removing old mod: $ZIP_NAME"
    rm "$OLD_MOD_PATH"
    if test $status -eq 0
        echo "✅ Old mod removed successfully"
    else
        echo "❌ Failed to remove old mod"
        exit 1
    end
else
    echo "ℹ️  No old mod found to remove"
end

# Create temporary directory for packing
set TEMP_DIR (mktemp -d)
set PACK_DIR "$TEMP_DIR/$MOD_NAME"

echo "📦 Packing mod..."

# Copy mod contents to temp directory
cp -r "$MOD_DIR" "$TEMP_DIR/"

# Navigate to temp directory and create zip
cd "$TEMP_DIR"
# Create zip with contents of the mod directory, not the directory itself
cd "$MOD_NAME"
zip -r "../$ZIP_NAME" . -x "*.DS_Store" "*.git*" "*.svn*" "*.hg*"
cd "$TEMP_DIR"

if test $status -eq 0
    echo "✅ Mod packed successfully: $ZIP_NAME"
else
    echo "❌ Failed to pack mod"
    rm -rf "$TEMP_DIR"
    exit 1
end

# Move packed mod to Vintage Story mods directory
echo "🚀 Installing mod to Vintage Story..."
mv "$ZIP_NAME" "$VS_MODS_DIR/"

if test $status -eq 0
    echo "✅ Mod installed successfully to: $VS_MODS_DIR/$ZIP_NAME"
else
    echo "❌ Failed to install mod"
    rm -rf "$TEMP_DIR"
    exit 1
end

# Clean up temporary directory
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 Success! Mod has been packed and installed."
echo "📁 Mod location: $VS_MODS_DIR/$ZIP_NAME"
echo "🎮 You can now start Vintage Story to use the mod."
echo ""
echo "📋 Mod contents:"
echo "   - modinfo.json"
echo "   - modicon.png"
echo "   - assets/nesmusic/"
echo "   - music system with environmental playback"
echo "   - physical music cylinders"




