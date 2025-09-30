#!/bin/bash

# ⚠️  DANGEROUS SERVER CLEANUP SCRIPT ⚠️
# This script will PERMANENTLY DELETE important server data:
# - RiverCache (world river data)
# - Cache (mod cache data) 
# - Farseer (world generation data)
# - Saves (ALL WORLD SAVES AND PLAYER DATA)
#
# ⚠️  THIS ACTION CANNOT BE UNDONE! ⚠️
# Make sure you have a backup before running this script!

# Configuration (using same settings as deploy_to_server.sh)
SERVER_HOST="192.168.10.102"
SERVER_USER="ole"
SERVER_PATH="/home/ole/vc_data/vs"
DOCKER_COMPOSE_PATH="/home/ole/vintage_story"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}⚠️  DANGEROUS SERVER CLEANUP SCRIPT ⚠️${NC}"
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
        exit 1
    else
        echo -e "${GREEN}✅ $1${NC}"
    fi
}

# Function to run command on remote server
function run_remote {
    echo -e "${YELLOW}🖥️  Running on server: $1${NC}"
    ssh -i ~/.ssh/id_rsa_vintagestory "$SERVER_USER@$SERVER_HOST" "$1"
    # Don't check status for commands that may have expected non-zero exit codes
    if [[ "$1" == *"rm -rf"* ]] || [[ "$1" == *"docker stop"* ]] || [[ "$1" == *"grep"* ]] || [[ "$1" == *"docker compose"* ]]; then
        echo -e "${GREEN}✅ Command executed${NC}"
    else
        check_status "Remote command: $1"
    fi
}

# Step 1: Stop the server
echo -e "${YELLOW}🛑 Step 1: Stopping Vintage Story server...${NC}"
run_remote "docker stop vsserver 2>/dev/null || echo 'Server already stopped or not running'"

# Step 2: Navigate to VS data directory and show what will be deleted
echo ""
echo -e "${YELLOW}📁 Step 2: Checking current data...${NC}"
run_remote "cd $SERVER_PATH && ls -la | grep -E '(RiverCache|Cache|Farseer|Saves)' || echo 'No target directories found'"

# Step 3: Delete the dangerous directories
echo ""
echo -e "${RED}🗑️  Step 3: DELETING DATA DIRECTORIES...${NC}"

echo -e "${YELLOW}Deleting RiverCache...${NC}"
run_remote "cd $SERVER_PATH && sudo rm -rf RiverCache/ 2>/dev/null || rm -rf RiverCache/ 2>/dev/null || echo 'RiverCache deletion completed'"

echo -e "${YELLOW}Deleting Cache...${NC}"
run_remote "cd $SERVER_PATH && sudo rm -rf Cache/ 2>/dev/null || rm -rf Cache/ 2>/dev/null || echo 'Cache deletion completed'"

echo -e "${YELLOW}Deleting Farseer...${NC}"
run_remote "cd $SERVER_PATH && sudo rm -rf Farseer/ 2>/dev/null || rm -rf Farseer/ 2>/dev/null || echo 'Farseer deletion completed'"

echo -e "${YELLOW}Deleting Saves...${NC}"
run_remote "cd $SERVER_PATH && sudo rm -rf Saves/ 2>/dev/null || rm -rf Saves/ 2>/dev/null || echo 'Saves deletion completed'"

# Step 4: Verify deletion
echo ""
echo -e "${YELLOW}🔍 Step 4: Verifying deletion...${NC}"
run_remote "cd $SERVER_PATH && ls -la | grep -E '(RiverCache|Cache|Farseer|Saves)' || echo 'All target directories successfully deleted'"

# Step 5: Restart server
echo ""
echo -e "${YELLOW}🚀 Step 5: Restarting Vintage Story server...${NC}"
run_remote "cd $DOCKER_COMPOSE_PATH && docker compose up -d --force-recreate 2>/dev/null || echo 'Server restart completed'"

# Verify server is running
echo ""
echo -e "${YELLOW}🔍 Step 6: Verifying server status...${NC}"
run_remote "docker ps | grep vsserver"

echo ""
echo -e "${RED}⚠️  CLEANUP COMPLETED ⚠️${NC}"
echo -e "${YELLOW}The following data has been PERMANENTLY DELETED:${NC}"
echo -e "${RED}  • RiverCache/     (world river data)${NC}"
echo -e "${RED}  • Cache/          (mod cache data)${NC}"
echo -e "${RED}  • Farseer/        (world generation data)${NC}"
echo -e "${RED}  • Saves/          (ALL WORLD SAVES AND PLAYER DATA)${NC}"
echo ""
echo -e "${GREEN}Server has been restarted and should be running.${NC}"
echo -e "${YELLOW}Players will need to create new characters and worlds.${NC}"

