#!/bin/bash

# Server backup script
# This script logs into the server, stops the Vintage Story server,
# and creates a backup using rsync

# Configuration (using same settings as deploy_to_server.sh)
SERVER_HOST="192.168.10.102"
SERVER_USER="ole"
SERVER_PATH="/home/ole/vc_data"
BACKUP_PREFIX="vs_"

# Get current date in YYYY_MM_DD format
CURRENT_DATE=$(date +%Y_%m_%d)
BACKUP_DIR="${BACKUP_PREFIX}${CURRENT_DATE}"

echo "Starting server backup process..."
echo "Server: ${SERVER_USER}@${SERVER_HOST}"
echo "Source: ${SERVER_PATH}/vs/"
echo "Backup: ${SERVER_PATH}/${BACKUP_DIR}"
echo ""

# SSH command to execute on the server (using same SSH key as deploy script)
ssh -i ~/.ssh/id_rsa_vintagestory ${SERVER_USER}@${SERVER_HOST} << EOF
    echo "Connected to server. Current directory: \$(pwd)"
    
    # Navigate to the Vintage Story data directory
    echo "Changing to ${SERVER_PATH}..."
    cd ${SERVER_PATH}
    
    # Stop the Vintage Story server
    echo "Stopping Vintage Story server..."
    docker stop vsserver
    
    # Wait a moment for the container to fully stop
    sleep 2
    
    # Check if vs directory exists
    if [ ! -d "vs" ]; then
        echo "ERROR: vs directory not found in ${SERVER_PATH}"
        exit 1
    fi
    
    # Create backup using rsync
    echo "Starting backup with rsync..."
    echo "Backup destination: ${BACKUP_DIR}"
    
    rsync -av --bwlimit=40000 --partial --append-verify --progress vs/ ${BACKUP_DIR}/
    
    # Check if backup was successful
    if [ \$? -eq 0 ]; then
        echo "Backup completed successfully!"
        echo "Backup location: ${SERVER_PATH}/${BACKUP_DIR}"
        
        # Show backup size
        echo "Backup size:"
        du -sh ${BACKUP_DIR}
    else
        echo "ERROR: Backup failed!"
        exit 1
    fi
    
    # Restart the server
    echo "Restarting Vintage Story server..."
    docker start vsserver
    
    echo "Server backup process completed!"
EOF

# Check if the SSH command was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Server backup completed successfully!"
    echo "Backup created: ${BACKUP_DIR}"
else
    echo ""
    echo "❌ Server backup failed!"
    exit 1
fi
