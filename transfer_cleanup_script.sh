#!/bin/bash

# Script to transfer the local cleanup script to the server

SERVER_HOST="192.168.10.102"
SERVER_USER="ole"
LOCAL_SCRIPT="cleanup_server_data_local.sh"
REMOTE_SCRIPT="cleanup_server_data_local.sh"

echo "🚀 Transferring cleanup script to server..."

# Transfer the script
scp -i ~/.ssh/id_rsa_vintagestory "$LOCAL_SCRIPT" "$SERVER_USER@$SERVER_HOST:~/$REMOTE_SCRIPT"

if [ $? -eq 0 ]; then
    echo "✅ Script transferred successfully!"
    echo ""
    echo "📋 To run the script on the server:"
    echo "1. SSH to the server:"
    echo "   ssh -i ~/.ssh/id_rsa_vintagestory ole@192.168.10.102"
    echo ""
    echo "2. Run the script:"
    echo "   chmod +x cleanup_server_data_local.sh"
    echo "   ./cleanup_server_data_local.sh"
    echo ""
    echo "⚠️  The script will run with proper local permissions and should work correctly."
else
    echo "❌ Failed to transfer script"
    exit 1
fi
