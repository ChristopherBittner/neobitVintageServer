#!/usr/bin/env fish

# Transfer Script for neobit Vintage Server (SSH Key Authentication)
# This script transfers mods and configs to remote server using SSH keys

set MODS_SOURCE "/home/neo/.var/app/at.vintagestory.VintageStory/config/VintagestoryData/ModsBAK"
set CONFIGS_SOURCE "/home/neo/Repositories/neobitVintageServer/configs"
set REMOTE_USER "ole"
set REMOTE_HOST "192.168.10.102"
set REMOTE_PATH "/home/ole"

echo "=== neobit Vintage Server Transfer Script (SSH Key) ==="
echo "Source Mods: $MODS_SOURCE"
echo "Source Configs: $CONFIGS_SOURCE"
echo "Remote: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
echo ""

# Check if source directories exist
if not test -d "$MODS_SOURCE"
    echo "❌ Error: Mods source directory not found: $MODS_SOURCE"
    exit 1
end

if not test -d "$CONFIGS_SOURCE"
    echo "❌ Error: Configs source directory not found: $CONFIGS_SOURCE"
    exit 1
end

# Test SSH connection
echo "🔐 Testing SSH connection..."
ssh -i ~/.ssh/id_rsa_vintagestory -o ConnectTimeout=10 -o BatchMode=yes "$REMOTE_USER@$REMOTE_HOST" "echo 'SSH connection successful'" 2>/dev/null
if test $status -ne 0
    echo "❌ Error: Cannot connect to remote server via SSH"
    echo "Please ensure:"
    echo "   1. SSH key is set up for passwordless authentication"
    echo "   2. Remote server is accessible at $REMOTE_HOST"
    echo "   3. User $REMOTE_USER exists on remote server"
    echo ""
    echo "To set up SSH key authentication:"
    echo "   ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'"
    echo "   ssh-copy-id $REMOTE_USER@$REMOTE_HOST"
    exit 1
end
echo "✅ SSH connection successful"

# Create remote directories if they don't exist
echo "📁 Creating remote directories..."
ssh -i ~/.ssh/id_rsa_vintagestory "$REMOTE_USER@$REMOTE_HOST" "mkdir -p $REMOTE_PATH/mods $REMOTE_PATH/configs"
if test $status -ne 0
    echo "❌ Failed to create remote directories"
    exit 1
end
echo "✅ Remote directories created"

# Transfer mods (zip files)
echo ""
echo "📦 Transferring mods..."
set mod_count (find "$MODS_SOURCE" -name "*.zip" | wc -l)
if test $mod_count -eq 0
    echo "⚠️  No zip files found in mods directory"
else
    echo "Found $mod_count zip files to transfer"
    scp -i ~/.ssh/id_rsa_vintagestory "$MODS_SOURCE"/*.zip "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/mods/"
    if test $status -eq 0
        echo "✅ Mods transferred successfully"
    else
        echo "❌ Failed to transfer mods"
        exit 1
    end
end

# Transfer configs
echo ""
echo "📋 Transferring configs..."
set config_count (find "$CONFIGS_SOURCE" \( -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) | wc -l)
if test $config_count -eq 0
    echo "⚠️  No config files found in configs directory"
else
    echo "Found $config_count config files to transfer"
    scp -i ~/.ssh/id_rsa_vintagestory -r "$CONFIGS_SOURCE"/* "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/configs/"
    if test $status -eq 0
        echo "✅ Configs transferred successfully"
    else
        echo "❌ Failed to transfer configs"
        exit 1
    end
end

echo ""
echo "🎉 Transfer completed successfully!"
echo "📁 Remote locations:"
echo "   Mods: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/mods/"
echo "   Configs: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/configs/"
echo ""
echo "📋 Summary:"
echo "   Mods transferred: $mod_count"
echo "   Configs transferred: $config_count"
