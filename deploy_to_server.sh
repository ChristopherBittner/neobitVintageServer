#!/usr/bin/env fish

# Comprehensive Deployment Script for neobit Vintage Server
# This script handles the complete deployment process:
# 1. Updates configs from collect_configs.json
# 2. Transfers files to server
# 3. Stops the server
# 4. Updates mods and configs on server
# 5. Restarts the server
#
# Usage: ./deploy_to_server.sh

set SCRIPT_DIR "/home/neo/Repositories/neobitVintageServer"
set REMOTE_USER "ole"
set REMOTE_HOST "192.168.10.102"
set REMOTE_PATH "/home/ole"
set VS_DATA_PATH "/home/ole/vc_data/vs"
set DOCKER_COMPOSE_PATH "/home/ole/vintage_story"

echo "=== neobit Vintage Server Deployment Script ==="
echo "Local Script Directory: $SCRIPT_DIR"
echo "Remote Server: $REMOTE_USER@$REMOTE_HOST"
echo "VS Data Path: $VS_DATA_PATH"
echo "Docker Compose Path: $DOCKER_COMPOSE_PATH"
echo ""

# Function to check if a command was successful
function check_status
    if test $status -ne 0
        echo "❌ Error: $argv[1]"
        exit 1
    else
        echo "✅ $argv[1]"
    end
end

# Function to run command on remote server
function run_remote
    echo "🖥️  Running on server: $argv[1]"
    ssh -i ~/.ssh/id_rsa_vintagestory "$REMOTE_USER@$REMOTE_HOST" "$argv[1]"
    check_status "Remote command: $argv[1]"
end

# Step 1: Update configs
echo "📋 Step 1: Updating configs..."
cd "$SCRIPT_DIR"
./update_configs.sh
check_status "Config update completed"

# Step 2: Transfer files to server
echo ""
echo "📦 Step 2: Transferring files to server..."
./transfer_to_server_sshkey.sh
check_status "File transfer completed"

# Step 3: Stop the server
echo ""
echo "🛑 Step 3: Stopping Vintage Story server..."
run_remote "docker stop vsserver"

# Step 4: Clean up old mods
echo ""
echo "🗑️  Step 4: Cleaning up old mods..."
run_remote "docker run --rm -v $VS_DATA_PATH:/data alpine:latest sh -c 'rm -rf /data/Mods/*'"
check_status "Old mods cleaned up"

# Step 5: Update mod configs
echo ""
echo "📋 Step 5: Updating mod configs..."
run_remote "docker run --rm -v $VS_DATA_PATH:/data -v $REMOTE_PATH/configs:/configs alpine:latest sh -c 'cp -r /configs/* /data/ModConfig/'"
check_status "Mod configs updated"

# Step 6: Update mods
echo ""
echo "📦 Step 6: Updating mods..."
run_remote "docker run --rm -v $VS_DATA_PATH:/data -v $REMOTE_PATH/mods:/mods alpine:latest sh -c 'cp /mods/* /data/Mods/'"
check_status "Mods updated"

# Step 7: Restart server
echo ""
echo "🚀 Step 7: Restarting Vintage Story server..."
run_remote "cd $DOCKER_COMPOSE_PATH && docker compose up -d --force-recreate"

# Verify server is running
echo ""
echo "🔍 Verifying server status..."
run_remote "docker ps | grep vsserver"

# Step 8: Clean up temporary files
echo ""
echo "🧹 Step 8: Cleaning up temporary files..."
run_remote "rm -rf $REMOTE_PATH/mods/* $REMOTE_PATH/configs/*"
check_status "Temporary files cleaned up"

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📋 Deployment Summary:"
echo "   ✅ Configs updated from collect_configs.json"
echo "   ✅ Files transferred to server"
echo "   ✅ Server stopped"
echo "   ✅ Old mods removed"
echo "   ✅ Mod configs updated"
echo "   ✅ Mods updated"
echo "   ✅ Server restarted with docker compose"
echo "   ✅ Temporary files cleaned up"
echo ""
echo "🌐 Server should now be running with updated mods and configs"
echo "📊 Check server status with: ssh $REMOTE_USER@$REMOTE_HOST 'docker ps | grep vsserver'"
