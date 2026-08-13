# Nova Server Installation Guide

## Overview

This guide provides complete instructions for installing and configuring Nova Server on Ubuntu 22.04 and Debian 12.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Manual Installation](#manual-installation)
4. [Cloud-Init Deployment](#cloud-init-deployment)
5. [Post-Installation Setup](#post-installation-setup)
6. [Configuration](#configuration)
7. [Troubleshooting](#troubleshooting)
8. [Maintenance](#maintenance)

---

## Prerequisites

### System Requirements

- **OS**: Ubuntu 22.04 LTS or Debian 12
- **RAM**: Minimum 2GB (4GB+ recommended)
- **Disk Space**: Minimum 10GB
- **CPU**: 1+ cores
- **Network**: Internet connectivity for downloads

### Required Access

- Root or sudo privileges
- SSH access to the server
- Open ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3000 (Nova)

---

## Quick Start

### Option 1: Automated Installation Script

```bash
# Download and run the installation script
curl -fsSL https://raw.githubusercontent.com/siyavash680/Siya/features/nova-installation/scripts/install-nova.sh | sudo bash
```

### Option 2: Cloud-Init (VPS Providers)

When creating a new VPS, use the cloud-init configuration:

1. Choose **Ubuntu 22.04** or **Debian 12** as your OS
2. In the VPS provider's dashboard, find "Cloud-Init" or "User Data" option
3. Paste the contents of `cloud-init.yml`
4. Create the VPS
5. Wait 5-10 minutes for automatic installation

---

## Manual Installation

### Step 1: Connect to Your Server

```bash
ssh root@your-server-ip
```

### Step 2: Update System

```bash
apt-get update
apt-get upgrade -y
```

### Step 3: Install Dependencies

```bash
apt-get install -y \
    curl wget git build-essential \
    python3 python3-pip python3-venv \
    nodejs npm openssl ssl-cert ca-certificates \
    systemd sudo ufw
```

### Step 4: Verify Installations

```bash
python3 --version
node --version
npm --version
```

### Step 5: Create Nova User and Directories

```bash
# Create user
useradd -r -s /bin/bash -d /opt/nova -m nova

# Create directories
sudo -u nova mkdir -p /opt/nova
mkdir -p /var/lib/nova
mkdir -p /var/log/nova

# Set permissions
chown -R nova:nova /opt/nova
chown -R nova:nova /var/lib/nova
chown -R nova:nova /var/log/nova
```

### Step 6: Download Nova Server

```bash
cd /tmp
# Replace URL with actual Nova Server download link
curl -O https://github.com/novaserver/nova/releases/download/latest/nova-server.tar.gz

# Extract to installation directory
tar -xzf nova-server.tar.gz -C /opt/nova --strip-components=1
chown -R nova:nova /opt/nova
```

### Step 7: Create Configuration File

```bash
cat > /opt/nova/config.json << 'EOF'
{
  "server": {
    "name": "Nova Server",
    "version": "1.0.0",
    "environment": "production",
    "port": 3000,
    "host": "0.0.0.0",
    "debug": false
  },
  "database": {
    "type": "sqlite",
    "path": "/var/lib/nova/nova.db"
  },
  "logging": {
    "level": "info",
    "dir": "/var/log/nova"
  },
  "security": {
    "enableSSL": true,
    "certPath": "/opt/nova/certs/nova-cert.pem",
    "keyPath": "/opt/nova/certs/nova-key.pem"
  }
}
EOF

chown nova:nova /opt/nova/config.json
chmod 644 /opt/nova/config.json
```

### Step 8: Create Systemd Service

```bash
cat > /etc/systemd/system/nova.service << 'EOF'
[Unit]
Description=Nova Server
After=network.target

[Service]
Type=simple
User=nova
Group=nova
WorkingDirectory=/opt/nova
ExecStart=/opt/nova/bin/nova-server --config=/opt/nova/config.json
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nova.service
systemctl start nova.service
```

### Step 9: Verify Installation

```bash
# Check service status
systemctl status nova.service

# View logs
journalctl -u nova -f

# Test connectivity
curl http://localhost:3000
```

---

## Cloud-Init Deployment

### For DigitalOcean

1. Click "Create" → "Droplets"
2. Choose Ubuntu 22.04 or Debian 12
3. Scroll to "Advanced Options"
4. Under "User data", paste:

```yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
  - curl
  - wget
  - git
  - build-essential
  - python3
  - python3-pip
  - nodejs
  - npm
  - openssl
  - ssl-cert
  - ca-certificates

runcmd:
  - curl -fsSL https://raw.githubusercontent.com/siyavash680/Siya/features/nova-installation/scripts/install-nova.sh | bash
  - ufw --force enable
  - ufw allow 22/tcp
  - ufw allow 80/tcp
  - ufw allow 443/tcp
  - ufw allow 3000/tcp
```

5. Create the Droplet
6. Wait 5-10 minutes for installation

---

## Post-Installation Setup

### Run Post-Installation Script

```bash
curl -fsSL https://raw.githubusercontent.com/siyavash680/Siya/features/nova-installation/scripts/setup-nova.sh | sudo bash
```

This script will:
- ✅ Setup SSL certificates
- ✅ Configure log rotation
- ✅ Initialize database
- ✅ Setup automated backups
- ✅ Configure monitoring
- ✅ Optimize system settings

---

## Configuration

### Update Configuration File

Edit the configuration:

```bash
sudo nano /opt/nova/config.json
```

Common settings:

| Setting | Description | Default |
|---------|-------------|---------|
| `server.port` | Server listening port | 3000 |
| `server.host` | Bind address | 0.0.0.0 |
| `database.path` | Database file location | /var/lib/nova/nova.db |
| `logging.level` | Log level (info, debug, error) | info |
| `security.enableSSL` | Enable HTTPS | true |

### Reload Configuration

```bash
systemctl restart nova.service
```

---

## Common Tasks

### Start/Stop Service

```bash
# Start
systemctl start nova.service

# Stop
systemctl stop nova.service

# Restart
systemctl restart nova.service

# Check status
systemctl status nova.service
```

### View Logs

```bash
# Real-time logs
journalctl -u nova -f

# Last 50 lines
journalctl -u nova -n 50

# Today's logs
journalctl -u nova --since today
```

### Create Backup

```bash
/usr/local/bin/nova-backup.sh
```

### Run Monitoring

```bash
/usr/local/bin/nova-monitor.sh
```

### View Service Configuration

```bash
cat /opt/nova/config.json
```

---

## Troubleshooting

### Service Won't Start

```bash
# Check logs
journalctl -u nova -n 50

# Check configuration
sudo -u nova /opt/nova/bin/nova-server --config=/opt/nova/config.json

# Check permissions
ls -la /opt/nova
ls -la /var/lib/nova
```

### Port Already in Use

```bash
# Check what's using port 3000
netstat -tlnp | grep 3000

# Change port in config
sudo nano /opt/nova/config.json
# Change "port": 3000 to another port

# Restart
systemctl restart nova.service
```

### Database Errors

```bash
# Check database file
ls -la /var/lib/nova/nova.db

# Reset database (WARNING: deletes data)
sudo -u nova rm /var/lib/nova/nova.db
systemctl restart nova.service
```

### SSL Certificate Issues

```bash
# Generate new self-signed certificate
sudo -u nova openssl req -x509 -newkey rsa:4096 \
  -keyout /opt/nova/certs/nova-key.pem \
  -out /opt/nova/certs/nova-cert.pem \
  -days 365 -nodes

# Restart service
systemctl restart nova.service
```

### Cannot Connect Remotely

1. Check firewall:
   ```bash
   ufw status
   ufw allow 3000/tcp
   ```

2. Check if listening on correct address:
   ```bash
   netstat -tlnp | grep nova
   ```

3. Check security groups/firewall rules in VPS provider

---

## Maintenance

### Regular Tasks

**Weekly:**
```bash
# Check disk space
df -h /var/lib/nova

# Review logs for errors
journalctl -u nova --since "7 days ago" | grep -i error
```

**Monthly:**
```bash
# Create backup
/usr/local/bin/nova-backup.sh

# Update system
apt-get update && apt-get upgrade -y

# Restart service
systemctl restart nova.service
```

**Quarterly:**
```bash
# Update Nova Server
# Check for new releases and follow upgrade instructions

# Review and optimize configuration
sudo nano /opt/nova/config.json

# Clean old backups
find /opt/nova-backups -name "*.tar.gz" -mtime +90 -delete
```

### Backup Strategy

Backups run automatically daily at 2 AM:
```bash
# View backup schedule
crontab -u nova -l

# List backups
ls -lh /opt/nova-backups/

# Restore from backup
tar -xzf /opt/nova-backups/nova-backup-*.tar.gz -C /var/lib/nova/
```

### Log Rotation

Logs are automatically rotated:
- Rotation interval: Daily
- Retention: 14 days
- Compression: Enabled

---

## Security Hardening

### Firewall Configuration

```bash
# Enable UFW
ufw --force enable

# Allow SSH
ufw allow 22/tcp

# Allow HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Allow Nova
ufw allow 3000/tcp

# Check rules
ufw status
```

### SSL/TLS Setup

1. **Generate self-signed certificate** (testing only):
   ```bash
   sudo -u nova openssl req -x509 -newkey rsa:4096 \
     -keyout /opt/nova/certs/nova-key.pem \
     -out /opt/nova/certs/nova-cert.pem \
     -days 365 -nodes
   ```

2. **Use Let's Encrypt** (production):
   ```bash
   apt-get install certbot
   certbot certonly --standalone -d your-domain.com
   
   # Update config to use certbot certificate
   sudo nano /opt/nova/config.json
   # Point to /etc/letsencrypt/live/your-domain.com/
   ```

### User Management

```bash
# List Nova user
id nova

# Change Nova user password
passwd nova

# Add sudo access
usermod -aG sudo nova
```

---

## Performance Tuning

### Increase File Descriptors

```bash
# Add to /etc/security/limits.conf
nova soft nofile 65536
nova hard nofile 65536

# Apply
sysctl -p
```

### Network Optimization

```bash
# Add to /etc/sysctl.conf
net.core.somaxconn = 4096
net.ipv4.tcp_max_syn_backlog = 4096

# Apply
sysctl -p
```

### Monitor Performance

```bash
# Real-time monitoring
top

# Or use the monitoring script
/usr/local/bin/nova-monitor.sh
```

---

## Upgrade Guide

### Backup Before Upgrade

```bash
/usr/local/bin/nova-backup.sh
```

### Upgrade Process

```bash
# Stop service
systemctl stop nova.service

# Download new version
cd /tmp
curl -O https://github.com/novaserver/nova/releases/download/VERSION/nova-server.tar.gz

# Backup current installation
cp -r /opt/nova /opt/nova-backup-$(date +%Y%m%d)

# Extract new version
tar -xzf nova-server.tar.gz -C /opt/nova --strip-components=1
chown -R nova:nova /opt/nova

# Start service
systemctl start nova.service

# Verify
systemctl status nova.service
```

---

## Support and Resources

- **Documentation**: https://github.com/siyavash680/Siya
- **Issues**: https://github.com/siyavash680/Siya/issues
- **Community**: Discussion forums and chat

---

## License

MIT License - See LICENSE file for details

---

**Last Updated**: 2026-08-13
**Version**: 1.0.0
