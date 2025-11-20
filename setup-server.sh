#!/bin/bash

# Complete Server Setup Script for AWS EC2
# Domain: ujjalkumardas.com

set -e

echo "🔧 Setting up production server for ujjalkumardas.com..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOMAIN="ujjalkumardas.com"
WEB_ROOT="/var/www/ujjalkumardas.com"

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
echo -e "${YELLOW}📦 Installing required packages...${NC}"
sudo apt-get install -y nginx git certbot python3-certbot-nginx ufw

# Create web root directory
echo -e "${YELLOW}📁 Creating web root directory...${NC}"
sudo mkdir -p $WEB_ROOT
sudo chown -R $USER:$USER $WEB_ROOT

# Configure firewall
echo -e "${YELLOW}🔥 Configuring firewall...${NC}"
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
sudo ufw --force enable
echo -e "${GREEN}✓ Firewall configured${NC}"

# Remove default Nginx site
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo -e "${YELLOW}🗑️  Removing default Nginx site...${NC}"
    sudo rm /etc/nginx/sites-enabled/default
fi

# Copy Nginx configuration
echo -e "${YELLOW}📋 Setting up Nginx configuration...${NC}"
if [ -f "nginx.conf" ]; then
    # First, create a temporary config without SSL for Let's Encrypt
    sudo tee /etc/nginx/sites-available/$DOMAIN > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    
    root $WEB_ROOT;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
    
    sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
    
    # Test and reload Nginx
    sudo nginx -t && sudo systemctl reload nginx
    echo -e "${GREEN}✓ Nginx configured${NC}"
else
    echo -e "${RED}✗ nginx.conf file not found${NC}"
    exit 1
fi

# Setup SSL with Let's Encrypt
echo -e "${YELLOW}🔒 Setting up SSL certificate...${NC}"
echo -e "${BLUE}Make sure your domain DNS is pointing to this server's IP address!${NC}"
read -p "Press Enter to continue with SSL setup..."

sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email contact@ujjalkumardas.com --redirect

# Update Nginx config with full SSL configuration
if [ -f "nginx.conf" ]; then
    sudo cp nginx.conf /etc/nginx/sites-available/$DOMAIN
    sudo nginx -t && sudo systemctl reload nginx
    echo -e "${GREEN}✓ SSL certificate installed and Nginx configured${NC}"
fi

# Setup auto-renewal for SSL
echo -e "${YELLOW}🔄 Setting up SSL auto-renewal...${NC}"
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
echo -e "${GREEN}✓ SSL auto-renewal configured${NC}"

# Clone and deploy the site
echo -e "${YELLOW}📥 Deploying website...${NC}"
if [ -f "deploy.sh" ]; then
    chmod +x deploy.sh
    ./deploy.sh
else
    echo -e "${YELLOW}📥 Cloning repository...${NC}"
    sudo git clone https://github.com/Ujjal-Techved/nasscom-poc.git $WEB_ROOT
    sudo chown -R www-data:www-data $WEB_ROOT
    sudo chmod -R 755 $WEB_ROOT
fi

# Enable and start Nginx
echo -e "${YELLOW}🚀 Starting Nginx...${NC}"
sudo systemctl enable nginx
sudo systemctl restart nginx

# Final status check
echo -e "${YELLOW}📊 Checking service status...${NC}"
sudo systemctl status nginx --no-pager -l

echo -e "${GREEN}"
echo "════════════════════════════════════════════════════════"
echo "✅ Server setup completed successfully!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "🌐 Your site should be live at:"
echo "   https://$DOMAIN"
echo "   https://www.$DOMAIN"
echo ""
echo "📝 Next steps:"
echo "   1. Verify DNS is pointing to this server"
echo "   2. Test the website in your browser"
echo "   3. Use deploy.sh for future updates"
echo ""
echo "🔧 Useful commands:"
echo "   sudo systemctl status nginx    # Check Nginx status"
echo "   sudo nginx -t                  # Test Nginx config"
echo "   sudo systemctl reload nginx    # Reload Nginx"
echo "   ./deploy.sh                   # Deploy updates"
echo "════════════════════════════════════════════════════════"
echo -e "${NC}"

