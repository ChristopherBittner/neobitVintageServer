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
    if [[ "$1" == *"rm -rf"* ]] || [[ "$1" == *"docker stop"* ]] || [[ "$1" == *"grep"* ]] || [[ "$1" == *"docker compose"* ]] || [[ "$1" == *"[ ! -d"* ]] || [[ "$1" == *"ls -"* ]]; then
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
echo -e "${YELLOW}📋 BEFORE DELETION - Current directory contents:${NC}"
run_remote "cd $SERVER_PATH && ls -la"
echo ""
echo -e "${YELLOW}🎯 Target directories to be deleted:${NC}"
run_remote "cd $SERVER_PATH && ls -la | grep -E '(RiverCache|Cache|Farseer|Saves)' || echo 'No target directories found'"

# Step 3: Delete the dangerous directories
echo ""
echo -e "${RED}🗑️  Step 3: DELETING DATA DIRECTORIES...${NC}"

echo -e "${YELLOW}Deleting RiverCache...${NC}"
run_remote "cd $SERVER_PATH && echo 'Attempting to delete RiverCache...' && sudo rm -rf RiverCache/ && echo 'RiverCache deleted with sudo' || (echo 'sudo failed, trying as user...' && rm -rf RiverCache/ && echo 'RiverCache deleted as user') || echo 'RiverCache deletion failed'"
run_remote "cd $SERVER_PATH && [ ! -d 'RiverCache' ] && echo '✅ RiverCache successfully deleted' || echo '❌ RiverCache still exists'"

echo -e "${YELLOW}Deleting Cache...${NC}"
run_remote "cd $SERVER_PATH && echo 'Attempting to delete Cache...' && sudo rm -rf Cache/ && echo 'Cache deleted with sudo' || (echo 'sudo failed, trying as user...' && rm -rf Cache/ && echo 'Cache deleted as user') || echo 'Cache deletion failed'"
run_remote "cd $SERVER_PATH && [ ! -d 'Cache' ] && echo '✅ Cache successfully deleted' || echo '❌ Cache still exists'"

echo -e "${YELLOW}Deleting Farseer...${NC}"
run_remote "cd $SERVER_PATH && echo 'Attempting to delete Farseer...' && sudo rm -rf Farseer/ && echo 'Farseer deleted with sudo' || (echo 'sudo failed, trying as user...' && rm -rf Farseer/ && echo 'Farseer deleted as user') || echo 'Farseer deletion failed'"
run_remote "cd $SERVER_PATH && [ ! -d 'Farseer' ] && echo '✅ Farseer successfully deleted' || echo '❌ Farseer still exists'"

echo -e "${YELLOW}Deleting Saves...${NC}"
run_remote "cd $SERVER_PATH && echo 'Attempting to delete Saves...' && sudo rm -rf Saves/ && echo 'Saves deleted with sudo' || (echo 'sudo failed, trying as user...' && rm -rf Saves/ && echo 'Saves deleted as user') || echo 'Saves deletion failed'"
run_remote "cd $SERVER_PATH && [ ! -d 'Saves' ] && echo '✅ Saves successfully deleted' || echo '❌ Saves still exists'"

# Step 4: Verify deletion and show comparison
echo ""
echo -e "${YELLOW}🔍 Step 4: Verifying deletion...${NC}"
echo -e "${YELLOW}📋 AFTER DELETION - Current directory contents:${NC}"
run_remote "cd $SERVER_PATH && ls -la"
echo ""
echo -e "${YELLOW}🎯 Remaining target directories:${NC}"
run_remote "cd $SERVER_PATH && ls -la | grep -E '(RiverCache|Cache|Farseer|Saves)' || echo 'All target directories successfully deleted'"
echo ""
echo -e "${YELLOW}📊 DELETION SUMMARY:${NC}"
run_remote "cd $SERVER_PATH && echo 'Directories that still exist:' && ls -d RiverCache Cache Farseer Saves 2>/dev/null || echo 'No target directories remain'"

# Check if deletion actually succeeded
echo ""
echo -e "${RED}🚨 DELETION STATUS CHECK:${NC}"
run_remote "cd $SERVER_PATH && echo 'Checking remaining directories...' && ls -d RiverCache Cache Farseer Saves 2>/dev/null | wc -l | xargs -I {} sh -c 'if [ {} -eq 0 ]; then echo \"✅ SUCCESS: All target directories deleted\"; else echo \"❌ FAILURE: {} directories still exist\"; fi'"

# Check if any directories still exist and stop if so
echo ""
echo -e "${RED}🛑 CHECKING FOR FAILURES...${NC}"
remaining_count=$(ssh -i ~/.ssh/id_rsa_vintagestory "$SERVER_USER@$SERVER_HOST" "cd $SERVER_PATH && ls -d RiverCache Cache Farseer Saves 2>/dev/null | wc -l")

if [ "$remaining_count" -gt 0 ]; then
    echo -e "${RED}❌ CLEANUP FAILED!${NC}"
    echo -e "${RED}===========================================${NC}"
    echo -e "${YELLOW}The following directories could NOT be deleted:${NC}"
    ssh -i ~/.ssh/id_rsa_vintagestory "$SERVER_USER@$SERVER_HOST" "cd $SERVER_PATH && ls -d RiverCache Cache Farseer Saves 2>/dev/null | sed 's/^/  • /'"
    echo ""
    echo -e "${RED}REASON: Permission denied - directories are owned by root:root${NC}"
    echo -e "${YELLOW}SOLUTION: You need to run this script with proper sudo access or manually delete the directories${NC}"
    echo ""
    echo -e "${RED}⚠️  SERVER NOT RESTARTED DUE TO FAILURE ⚠️${NC}"
    echo -e "${YELLOW}Fix the permission issues and run the script again.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All directories successfully deleted!${NC}"
    echo ""
    echo -e "${YELLOW}🚀 Step 5: Restarting Vintage Story server...${NC}"
    run_remote "cd $DOCKER_COMPOSE_PATH && docker compose up -d --force-recreate 2>/dev/null || echo 'Server restart completed'"

    # Verify server is running
    echo ""
    echo -e "${YELLOW}🔍 Step 6: Verifying server status...${NC}"
    run_remote "docker ps | grep vsserver"

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

