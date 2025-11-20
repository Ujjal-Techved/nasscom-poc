# Quick Start Guide - Deploy to AWS EC2

## Prerequisites Checklist

- [ ] AWS EC2 instance running (Ubuntu 20.04/22.04 recommended)
- [ ] EC2 Security Group allows:
  - [ ] Port 22 (SSH)
  - [ ] Port 80 (HTTP)
  - [ ] Port 443 (HTTPS)
- [ ] Domain DNS configured:
  - [ ] A record: `ujjalkumardas.com` → EC2 Public IP
  - [ ] A record: `www.ujjalkumardas.com` → EC2 Public IP
- [ ] SSH key file (.pem) downloaded
- [ ] EC2 Public IP address noted

---

## Step-by-Step Deployment

### Step 1: Get Your EC2 Information

1. **Get EC2 Public IP**:
   - Go to AWS Console → EC2 → Instances
   - Copy the "Public IPv4 address"

2. **Get SSH Key Path**:
   - Note the path to your `.pem` file
   - Example: `C:\Users\YourName\Downloads\my-key.pem`

---

### Step 2: Upload Files to EC2

#### Option A: Using PowerShell Script (Easiest)

1. Open PowerShell in this directory
2. Run:
```powershell
.\upload-to-ec2.ps1 -EC2IP "YOUR_EC2_IP" -KeyPath "C:\path\to\your-key.pem"
```

#### Option B: Manual Upload with SCP

```powershell
# Upload files one by one
scp -i "C:\path\to\your-key.pem" nginx.conf ubuntu@YOUR_EC2_IP:~/
scp -i "C:\path\to\your-key.pem" setup-server.sh ubuntu@YOUR_EC2_IP:~/
scp -i "C:\path\to\your-key.pem" deploy.sh ubuntu@YOUR_EC2_IP:~/
```

#### Option C: Use Git on Server (Recommended)

This is the easiest - no file upload needed!

---

### Step 3: Connect to EC2

```powershell
ssh -i "C:\path\to\your-key.pem" ubuntu@YOUR_EC2_IP
```

**Note**: If using Amazon Linux, replace `ubuntu` with `ec2-user`

---

### Step 4: On the EC2 Server

Once connected, run these commands:

```bash
# Clone the repository (if not already done)
git clone https://github.com/Ujjal-Techved/nasscom-poc.git
cd nasscom-poc

# Make scripts executable
chmod +x setup-server.sh deploy.sh

# Run the complete setup
./setup-server.sh
```

The setup script will:
- ✅ Install all required packages (Nginx, Certbot, etc.)
- ✅ Configure firewall
- ✅ Setup Nginx
- ✅ Install SSL certificate
- ✅ Deploy your website
- ✅ Configure auto-renewal

**Important**: Make sure DNS is configured before running setup-server.sh!

---

### Step 5: Verify Deployment

1. **Check Nginx status**:
```bash
sudo systemctl status nginx
```

2. **Test your website**:
   - Open browser: https://ujjalkumardas.com
   - Should see your portfolio!

---

## Troubleshooting

### Can't connect via SSH?
- Check Security Group allows port 22
- Verify key file permissions (Windows: right-click → Properties → Security)
- Try: `ssh -v -i your-key.pem ubuntu@YOUR_EC2_IP` for verbose output

### SSL certificate fails?
- DNS must be configured first
- Wait 10-15 minutes after DNS changes
- Check: `nslookup ujjalkumardas.com` (should show your EC2 IP)

### Nginx won't start?
```bash
sudo nginx -t  # Test configuration
sudo tail -f /var/log/nginx/error.log  # Check errors
```

### Permission denied?
```bash
sudo chmod +x setup-server.sh deploy.sh
```

---

## Future Updates

To update your website after making changes:

```bash
# On EC2 server
cd ~/nasscom-poc  # or wherever you cloned it
git pull
./deploy.sh
```

Or if you want to pull from GitHub directly:

```bash
./deploy.sh
```

---

## Quick Commands Reference

```bash
# Check Nginx status
sudo systemctl status nginx

# Reload Nginx (after config changes)
sudo systemctl reload nginx

# Test Nginx configuration
sudo nginx -t

# Check SSL certificate
sudo certbot certificates

# View website logs
sudo tail -f /var/log/nginx/ujjalkumardas.com.access.log
sudo tail -f /var/log/nginx/ujjalkumardas.com.error.log

# Check disk space
df -h

# Check memory
free -h
```

---

## Need Help?

1. Check logs: `sudo tail -f /var/log/nginx/error.log`
2. Verify DNS: `nslookup ujjalkumardas.com`
3. Check firewall: `sudo ufw status`
4. Test SSL: `sudo certbot certificates`

---

**Your site will be live at: https://ujjalkumardas.com** 🚀

