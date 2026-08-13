# Nova Server Installation Scripts

This directory contains all scripts and documentation for installing Nova Server on Ubuntu 22.04 and Debian 12.

## 📁 Contents

- **install-nova.sh** - Main installation script
- **cloud-init.yml** - Cloud-Init configuration for automated VPS setup
- **setup-nova.sh** - Post-installation configuration script

## 🚀 Quick Start

### Automated Installation
```bash
curl -fsSL https://raw.githubusercontent.com/siyavash680/Siya/main/scripts/install-nova.sh | sudo bash
```

### Cloud-Init (VPS Providers)
Use `cloud-init.yml` in your VPS provider's user data field.

## 📖 Documentation

Complete installation guide available in `docs/NOVA_INSTALLATION_GUIDE.md`

## ✨ Features

- ✅ Automatic system detection (Ubuntu/Debian)
- ✅ All dependencies installed
- ✅ Systemd service setup
- ✅ SSL/TLS support
- ✅ Log rotation
- ✅ Automated backups
- ✅ Health monitoring
- ✅ Firewall configuration

## 🔧 Requirements

- Root or sudo access
- Ubuntu 22.04 or Debian 12
- 2GB+ RAM
- 10GB+ disk space
- Internet connectivity

## 📚 Documentation

See [NOVA_INSTALLATION_GUIDE.md](../docs/NOVA_INSTALLATION_GUIDE.md) for complete documentation.
