#!/bin/bash

# Nova Server Cloud-Init Installation Script
# This script is designed to be used as cloud-init user data for VPS providers
# Copy and paste this entire script into your VPS provider's cloud-init field

set -e

# Log output
exec > >(tee -a /var/log/nova-install.log)
exec 2>&1

echo "======================================"
echo "🚀 Nova Server Installation Starting"
echo "======================================"
echo "Timestamp: $(date)"
echo ""

# Update system packages
echo "📦 Updating system packages..."
apt-get update
apt-get upgrade -y

# Set admin password
export NOVA_ADMIN_PASS='yjjutUjSSSsVpPCffnir'

# Run the Nova installation script
echo "⏳ Installing Nova Server..."
echo "This may take several minutes..."
echo ""

NOVA_ADMIN_PASS='yjjutUjSSSsVpPCffnir' bash -c "bash <(curl -fsSL https://raw.githubusercontent.com/IRNova/Nova-Server/main/nova-node.sh)"

# Installation complete
echo ""
echo "======================================"
echo "✅ Nova Server Installation Completed!"
echo "======================================"
echo ""
echo "📝 Login Information:"
echo "   Username: admin"
echo "   Password: yjjutUjSSSsVpPCffnir"
echo ""
echo "⚠️  IMPORTANT: Change your password after first login!"
echo ""
echo "Installation log saved to: /var/log/nova-install.log"
