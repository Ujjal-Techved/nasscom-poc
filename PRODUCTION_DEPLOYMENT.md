# Production Deployment Guide - AWS EC2
## Domain: ujjalkumardas.com

This guide will help you deploy your portfolio to AWS EC2 with your custom domain.

---

## Prerequisites

1. **AWS EC2 Instance** running Ubuntu 20.04/22.04 or Amazon Linux 2
2. **Domain**: ujjalkumardas.com (DNS configured)
3. **SSH access** to your EC2 instance
4. **Security Group** configured to allow:
   - SSH (port 22)
   - HTTP (port 80)
   - HTTPS (port 443)

---

## Step 1: Configure DNS

Before starting, make sure your domain DNS is configured:

1. **Get your EC2 Public IP**:
   ```bash
   # From your local machine, get the instance IP from AWS Console
   # Or use: curl ifconfig.me (from EC2 instance)
   ```

2. **Configure DNS Records** (in your domain registrar):
   - **A Record**: `ujjalkumardas.com` → `YOUR_EC2_IP`
   - **A Record**: `www.ujjalkumardas.com` → `YOUR_EC2_IP`

3. **Wait for DNS propagation** (can take 5 minutes to 48 hours)

---

## Step 2: Connect to EC2 Instance

```bash
# From your local machine
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Or if using Amazon Linux
ssh -i your-key.pem ec2-user@YOUR_EC2_IP
```

---

## Step 3: Upload Files to Server

### Option A: Using SCP (from local machine)

```bash
# Navigate to your project directory
cd C:\Users\TVDMUMUD740\Desktop\Cursor-POC

# Upload files
scp -i your-key.pem nginx.conf ubuntu@YOUR_EC2_IP:~/
scp -i your-key.pem setup-server.sh ubuntu@YOUR_EC2_IP:~/
scp -i your-key.pem deploy.sh ubuntu@YOUR_EC2_IP:~/
```

### Option B: Using Git (on server)

```bash
# On EC2 instance
git clone https://github.com/Ujjal-Techved/nasscom-poc.git
cd nasscom-poc
```

---

## Step 4: Run Setup Script

```bash
# Make scripts executable
chmod +x setup-server.sh
chmod +x deploy.sh

# Run the complete setup
./setup-server.sh
```

The script will:
- ✅ Update system packages
- ✅ Install Nginx, Git, Certbot
- ✅ Configure firewall
- ✅ Setup Nginx configuration
- ✅ Install SSL certificate (Let's Encrypt)
- ✅ Deploy your website
- ✅ Configure auto-renewal for SSL

---

## Step 5: Verify Deployment

1. **Check Nginx status**:
   ```bash
   sudo systemctl status nginx
   ```

2. **Test Nginx configuration**:
   ```bash
   sudo nginx -t
   ```

3. **Visit your website**:
   - https://ujjalkumardas.com
   - https://www.ujjalkumardas.com

---

## Future Updates

To deploy updates, simply run:

```bash
./deploy.sh
```

This script will:
- Backup current site
- Pull latest changes from GitHub
- Deploy to production
- Reload Nginx

---

## Manual Deployment Steps

If you prefer manual setup:

### 1. Install Nginx
```bash
sudo apt-get update
sudo apt-get install -y nginx
```

### 2. Install SSL Certificate
```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d ujjalkumardas.com -d www.ujjalkumardas.com
```

### 3. Configure Nginx
```bash
sudo cp nginx.conf /etc/nginx/sites-available/ujjalkumardas.com
sudo ln -s /etc/nginx/sites-available/ujjalkumardas.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Deploy Website
```bash
sudo git clone https://github.com/Ujjal-Techved/nasscom-poc.git /var/www/ujjalkumardas.com
sudo chown -R www-data:www-data /var/www/ujjalkumardas.com
sudo chmod -R 755 /var/www/ujjalkumardas.com
```

---

## Troubleshooting

### Nginx won't start
```bash
sudo nginx -t  # Check for configuration errors
sudo tail -f /var/log/nginx/error.log  # Check error logs
```

### SSL certificate issues
```bash
sudo certbot certificates  # List certificates
sudo certbot renew --dry-run  # Test renewal
```

### Permission issues
```bash
sudo chown -R www-data:www-data /var/www/ujjalkumardas.com
sudo chmod -R 755 /var/www/ujjalkumardas.com
```

### Check if ports are open
```bash
sudo ufw status
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

---

## Security Checklist

- ✅ Firewall configured (UFW)
- ✅ SSL certificate installed
- ✅ Auto-renewal enabled
- ✅ Security headers configured
- ✅ Nginx running as non-root user
- ✅ Regular backups configured

---

## Backup Strategy

Backups are automatically created in `/var/backups/ujjalkumardas.com/` during deployment.

To manually backup:
```bash
sudo tar -czf /var/backups/ujjalkumardas.com/manual-backup-$(date +%Y%m%d).tar.gz -C /var/www/ujjalkumardas.com .
```

---

## Monitoring

### Check Nginx logs
```bash
sudo tail -f /var/log/nginx/ujjalkumardas.com.access.log
sudo tail -f /var/log/nginx/ujjalkumardas.com.error.log
```

### Monitor server resources
```bash
htop  # Install with: sudo apt-get install htop
df -h  # Check disk space
free -h  # Check memory
```

---

## Support

If you encounter issues:
1. Check Nginx error logs
2. Verify DNS configuration
3. Check EC2 Security Group settings
4. Ensure SSL certificate is valid

---

**Your portfolio will be live at: https://ujjalkumardas.com**

