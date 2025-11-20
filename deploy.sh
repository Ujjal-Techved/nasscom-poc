#!/bin/bash

# Portfolio Deployment Script for AWS EC2
# Domain: ujjalkumardas.com

set -e

echo "🚀 Starting deployment for ujjalkumardas.com..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="ujjalkumardas.com"
WEB_ROOT="/var/www/ujjalkumardas.com"
REPO_URL="https://github.com/Ujjal-Techved/nasscom-poc.git"
BACKUP_DIR="/var/backups/ujjalkumardas.com"

# Create web root if it doesn't exist
echo -e "${YELLOW}📁 Creating web root directory...${NC}"
sudo mkdir -p $WEB_ROOT
sudo chown -R $USER:$USER $WEB_ROOT

# Create backup directory
sudo mkdir -p $BACKUP_DIR

# Backup existing site
if [ -d "$WEB_ROOT" ] && [ "$(ls -A $WEB_ROOT)" ]; then
    echo -e "${YELLOW}💾 Creating backup...${NC}"
    BACKUP_NAME="backup-$(date +%Y%m%d-%H%M%S)"
    sudo tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" -C $WEB_ROOT .
    echo -e "${GREEN}✓ Backup created: $BACKUP_DIR/$BACKUP_NAME.tar.gz${NC}"
fi

# Clone or update repository
TEMP_DIR=$(mktemp -d)
echo -e "${YELLOW}📥 Cloning repository...${NC}"
git clone $REPO_URL $TEMP_DIR

# Copy files to web root
echo -e "${YELLOW}📋 Copying files...${NC}"
sudo cp -r $TEMP_DIR/* $WEB_ROOT/
sudo rm -rf $TEMP_DIR

# Set proper permissions
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
sudo chown -R www-data:www-data $WEB_ROOT
sudo chmod -R 755 $WEB_ROOT
sudo find $WEB_ROOT -type f -exec chmod 644 {} \;

# Test Nginx configuration
echo -e "${YELLOW}🧪 Testing Nginx configuration...${NC}"
if sudo nginx -t; then
    echo -e "${GREEN}✓ Nginx configuration is valid${NC}"
    
    # Reload Nginx
    echo -e "${YELLOW}🔄 Reloading Nginx...${NC}"
    sudo systemctl reload nginx
    echo -e "${GREEN}✓ Nginx reloaded successfully${NC}"
else
    echo -e "${RED}✗ Nginx configuration test failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Your site should be live at: https://$DOMAIN${NC}"

