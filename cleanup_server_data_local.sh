#!/bin/bash

# ⚠️  DANGEROUS SERVER CLEANUP SCRIPT (LOCAL VERSION) ⚠️
# This script will PERMANENTLY DELETE important server data:
# - RiverCache (world river data)
# - Cache (mod cache data) 
# - Farseer (world generation data)
# - Saves (ALL WORLD SAVES AND PLAYER DATA)
#
# ⚠️  THIS ACTION CANNOT BE UNDONE! ⚠️
# Make sure you have a backup before running this script!

# Configuration
SERVER_PATH="/home/ole/vc_data/vs"
DOCKER_COMPOSE_PATH="/home/ole/vintage_story"
CONTAINER_NAME="vsserver"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}⚠️  DANGEROUS SERVER CLEANUP SCRIPT (LOCAL) ⚠️${NC}"
echo -e "${RED}===========================================${NC}"
echo ""
echo -e "${YELLOW}This script will PERMANENTLY DELETE:${NC}"
echo -e "${RED}  • RiverCache/     (world river data)${NC}"
echo -e "${RED}  • Cache/          (mod cache data)${NC}"
echo -e "${RED}  • Farseer/        (world generation data)${NC}"
echo -e "${RED}  • Saves/          (ALL WORLD SAVES AND PLAYER DATA)${NC}"
echo ""
echo -e "${YELLOW}This action CANNOT be undone!${NC}"
echo -e "${YELLOW}Make sure you have a backup before proceeding!${NC}"
echo ""

# First confirmation
echo -e "${RED}Are you absolutely sure you want to delete all this data?${NC}"
echo -e "${YELLOW}Type 'DELETE' to continue:${NC}"
read -r first_confirm

if [ "$first_confirm" != "DELETE" ]; then
    echo -e "${GREEN}Operation cancelled. No data was deleted.${NC}"
    exit 0
fi

echo ""
echo -e "${RED}⚠️  FINAL WARNING ⚠️${NC}"
echo -e "${YELLOW}This is your last chance to cancel!${NC}"
echo -e "${RED}Type 'YES' to proceed:${NC}"
read -r second_confirm

if [ "$second_confirm" != "YES" ]; then
    echo -e "${GREEN}Operation cancelled. No data was deleted.${NC}"
    exit 0
fi

echo ""
echo -e "${RED}Proceeding with data deletion...${NC}"
echo ""

# Function to check if a command was successful
function check_status {
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: $1${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $1${NC}"
        return 0
    fi
}

# Function to delete a directory with proper error handling
function delete_directory {
    local dir_name="$1"
    local dir_path="$SERVER_PATH/$dir_name"
    
    echo -e "${YELLOW}Deleting $dir_name...${NC}"
    
    if [ -d "$dir_path" ]; then
        echo "Attempting to delete $dir_name..."
        if rm -rf "$dir_path" 2>/dev/null; then
            echo "✅ $dir_name deleted successfully"
        else
            echo "❌ Failed to delete $dir_name - trying with sudo..."
            if sudo rm -rf "$dir_path" 2>/dev/null; then
                echo "✅ $dir_name deleted with sudo"
            else
                echo "❌ $dir_name deletion failed completely"
                return 1
            fi
        fi
        
        # Verify deletion
        if [ ! -d "$dir_path" ]; then
            echo "✅ $dir_name successfully deleted"
            return 0
        else
            echo "❌ $dir_name still exists"
            return 1
        fi
    else
        echo "ℹ️  $dir_name does not exist (already deleted)"
        return 0
    fi
}

# Step 1: Stop the server
echo -e "${YELLOW}🛑 Step 1: Stopping Vintage Story server...${NC}"
if docker stop "$CONTAINER_NAME" 2>/dev/null; then
    echo "✅ Server stopped"
else
    echo "ℹ️  Server was already stopped or not running"
fi

# Step 2: Show current data
echo ""
echo -e "${YELLOW}📁 Step 2: Checking current data...${NC}"
echo -e "${YELLOW}📋 BEFORE DELETION - Current directory contents:${NC}"
ls -la "$SERVER_PATH"
echo ""
echo -e "${YELLOW}🎯 Target directories to be deleted:${NC}"
ls -la "$SERVER_PATH" | grep -E '(RiverCache|Cache|Farseer|Saves)' || echo 'No target directories found'

# Step 3: Delete the dangerous directories
echo ""
echo -e "${RED}🗑️  Step 3: DELETING DATA DIRECTORIES...${NC}"

# Track deletion results
deletion_failed=false

if ! delete_directory "RiverCache"; then
    deletion_failed=true
fi

if ! delete_directory "Cache"; then
    deletion_failed=true
fi

if ! delete_directory "Farseer"; then
    deletion_failed=true
fi

if ! delete_directory "Saves"; then
    deletion_failed=true
fi

# Step 4: Verify deletion
echo ""
echo -e "${YELLOW}🔍 Step 4: Verifying deletion...${NC}"
echo -e "${YELLOW}📋 AFTER DELETION - Current directory contents:${NC}"
ls -la "$SERVER_PATH"
echo ""
echo -e "${YELLOW}🎯 Remaining target directories:${NC}"
ls -la "$SERVER_PATH" | grep -E '(RiverCache|Cache|Farseer|Saves)' || echo 'All target directories successfully deleted'
echo ""
echo -e "${YELLOW}📊 DELETION SUMMARY:${NC}"
remaining_dirs=$(ls -d "$SERVER_PATH"/RiverCache "$SERVER_PATH"/Cache "$SERVER_PATH"/Farseer "$SERVER_PATH"/Saves 2>/dev/null | wc -l)
if [ "$remaining_dirs" -eq 0 ]; then
    echo "✅ SUCCESS: All target directories deleted"
else
    echo "❌ FAILURE: $remaining_dirs directories still exist"
    deletion_failed=true
fi

# Check if deletion failed
if [ "$deletion_failed" = true ]; then
    echo ""
    echo -e "${RED}❌ CLEANUP FAILED!${NC}"
    echo -e "${RED}===========================================${NC}"
    echo -e "${YELLOW}The following directories could NOT be deleted:${NC}"
    ls -d "$SERVER_PATH"/RiverCache "$SERVER_PATH"/Cache "$SERVER_PATH"/Farseer "$SERVER_PATH"/Saves 2>/dev/null | sed 's/^/  • /' || echo "  (Unable to list remaining directories)"
    echo ""
    echo -e "${RED}REASON: Permission denied or other deletion errors${NC}"
    echo -e "${YELLOW}SOLUTION: Check permissions and try again${NC}"
    echo ""
    echo -e "${RED}⚠️  SERVER NOT RESTARTED DUE TO FAILURE ⚠️${NC}"
    echo -e "${YELLOW}Fix the issues and run the script again.${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}✅ All directories successfully deleted!${NC}"
    echo ""
    echo -e "${YELLOW}🚀 Step 5: Restarting Vintage Story server...${NC}"
    if cd "$DOCKER_COMPOSE_PATH" && docker compose up -d --force-recreate; then
        echo "✅ Server restart command executed"
    else
        echo "❌ Server restart failed"
        exit 1
    fi

    # Verify server is running
    echo ""
    echo -e "${YELLOW}🔍 Step 6: Verifying server status...${NC}"
    if docker ps | grep "$CONTAINER_NAME"; then
        echo "✅ Server is running"
    else
        echo "❌ Server is not running"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}✅ CLEANUP COMPLETED SUCCESSFULLY!${NC}"
    echo -e "${YELLOW}The following data has been PERMANENTLY DELETED:${NC}"
    echo -e "${RED}  • RiverCache/     (world river data)${NC}"
    echo -e "${RED}  • Cache/          (mod cache data)${NC}"
    echo -e "${RED}  • Farseer/        (world generation data)${NC}"
    echo -e "${RED}  • Saves/          (ALL WORLD SAVES AND PLAYER DATA)${NC}"
    echo ""
    echo -e "${GREEN}Server has been restarted and should be running.${NC}"
    echo -e "${YELLOW}Players will need to create new characters and worlds.${NC}"
fi
