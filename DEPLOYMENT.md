# neobit Vintage Server Deployment Guide

This guide explains how to use the deployment scripts for the neobit Vintage Server project.

## Overview

The deployment system consists of several scripts that work together to:
1. Update configuration files from `collect_configs.json`
2. Transfer mods and configs to the remote server
3. Stop the Vintage Story server
4. Update mods and configs on the server
5. Restart the server

## Scripts

### 1. `deploy_to_server.sh` - Main Deployment Script
**Purpose**: Executes the complete deployment process
**Usage**: `./deploy_to_server.sh`

**What it does**:
1. Calls `update_configs.sh` to update configs from `collect_configs.json`
2. Calls `transfer_to_server_sshkey.sh` to transfer files to server
3. Stops the Vintage Story server (`docker stop vsserver`)
4. Removes all files from `/home/ole/vc_data/vs/Mods`
5. Copies configs from `/home/ole/configs` to `/home/ole/vc_data/vs/ModConfig`
6. Copies mods from `/home/ole/mods` to `/home/ole/vc_data/vs/Mods`
7. Restarts the server (`docker compose up -d --force-recreate`)

### 2. `deploy_to_server_dryrun.sh` - Dry Run Script
**Purpose**: Shows what would be executed without making actual changes
**Usage**: `./deploy_to_server_dryrun.sh`

**What it does**:
- Displays all commands that would be executed
- Shows the effects of each step
- Useful for testing and verification before actual deployment

### 3. `update_configs.sh` - Config Management
**Purpose**: Updates configuration files based on `collect_configs.json`
**Usage**: `./update_configs.sh`

**What it does**:
- Reads configuration from `collect_configs.json`
- Copies config files from Vintage Story ModConfig directory
- Modifies values based on the JSON configuration
- Supports nested JSON structures

### 4. `transfer_to_server_sshkey.sh` - File Transfer
**Purpose**: Transfers mods and configs to remote server using SSH keys
**Usage**: `./transfer_to_server_sshkey.sh`

**What it does**:
- Transfers mod zip files to `/home/ole/mods/`
- Transfers config files to `/home/ole/configs/`
- Uses SSH key authentication for secure transfer

## Prerequisites

### Local Machine
- Fish shell installed
- `jq` installed for JSON processing
- `yq` installed for YAML processing (optional)
- SSH key set up for passwordless authentication to server

### Remote Server
- Docker installed and running
- Vintage Story server container named `vsserver`
- Docker Compose setup in `/home/ole/vintage_story`
- Proper directory structure:
  - `/home/ole/vc_data/vs/Mods/` - Mod files
  - `/home/ole/vc_data/vs/ModConfig/` - Mod configuration files
  - `/home/ole/mods/` - Temporary mod storage
  - `/home/ole/configs/` - Temporary config storage

## Configuration

### Server Settings
The deployment scripts use the following default settings:
- **Remote User**: `ole`
- **Remote Host**: `192.168.10.102`
- **Remote Path**: `/home/ole`
- **VS Data Path**: `/home/ole/vc_data/vs`
- **Docker Compose Path**: `/home/ole/vintage_story`

### SSH Key Setup
To set up passwordless SSH authentication:

```bash
# Generate SSH key (if not already done)
ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'

# Copy public key to server
ssh-copy-id ole@192.168.10.102

# Test connection
ssh ole@192.168.10.102 'echo "SSH connection successful"'
```

## Usage Examples

### 1. Test Deployment (Dry Run)
```bash
cd /home/neo/Repositories/neobitVintageServer
./deploy_to_server_dryrun.sh
```

### 2. Execute Full Deployment
```bash
cd /home/neo/Repositories/neobitVintageServer
./deploy_to_server.sh
```

### 3. Update Only Configs
```bash
cd /home/neo/Repositories/neobitVintageServer
./update_configs.sh
```

### 4. Transfer Files Only
```bash
cd /home/neo/Repositories/neobitVintageServer
./transfer_to_server_sshkey.sh
```

## Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   - Verify SSH key is set up correctly
   - Check if server is accessible at the specified IP
   - Ensure user exists on remote server

2. **Docker Commands Failed**
   - Verify Docker is running on remote server
   - Check if container name `vsserver` exists
   - Ensure user has Docker permissions

3. **File Transfer Failed**
   - Check if source directories exist
   - Verify remote directories are writable
   - Check disk space on remote server

4. **Config Update Failed**
   - Verify `collect_configs.json` is valid JSON
   - Check if source config files exist
   - Ensure `jq` is installed for JSON processing

### Debugging

1. **Check Server Status**
   ```bash
   ssh ole@192.168.10.102 'docker ps | grep vsserver'
   ```

2. **Check Directory Structure**
   ```bash
   ssh ole@192.168.10.102 'ls -la /home/ole/vc_data/vs/'
   ```

3. **Check Logs**
   ```bash
   ssh ole@192.168.10.102 'docker logs vsserver'
   ```

## Safety Features

- **Dry Run Mode**: Test deployments without making changes
- **Error Handling**: Scripts stop on first error
- **Status Verification**: Each step is verified before proceeding
- **Backup Safety**: Old mods are removed only after successful transfer

## File Structure

```
/home/neo/Repositories/neobitVintageServer/
├── deploy_to_server.sh          # Main deployment script
├── deploy_to_server_dryrun.sh   # Dry run script
├── update_configs.sh            # Config management script
├── transfer_to_server_sshkey.sh # File transfer script
├── collect_configs.json         # Configuration definitions
├── configs/                     # Generated config files
└── DEPLOYMENT.md               # This documentation
```

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Run the dry run script to verify commands
3. Check server logs for specific errors
4. Verify all prerequisites are met
