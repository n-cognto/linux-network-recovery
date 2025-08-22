#!/bin/bash

# Script: restore-nm.sh
# Description: Automates the process of restoring network connectivity and reinstalling Network Manager
# Author: n-cognto
# License: MIT

# Enhanced logging configuration
LOG_DIR="/var/log/network-recovery"
LOG_FILE="$LOG_DIR/restore-nm.log"
DEBUG_LOG="$LOG_DIR/debug.log"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Configure logging with rotation
if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE") -gt 1048576 ]; then
    mv "$LOG_FILE" "$LOG_FILE.old"
fi

# Function for different log levels
log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"
}

log_debug() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] $1" | tee -a "$DEBUG_LOG"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2"
}

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    log "Error: Please run as root"
    exit 1
fi

# Get interface name
read -p "Enter interface (e.g., wlan0): " IFACE
if [ -z "$IFACE" ]; then
    log "Error: Interface name cannot be empty"
    exit 1
fi

# Check if interface exists
if ! ip link show "$IFACE" &> /dev/null; then
    log "Error: Interface $IFACE does not exist"
    exit 1
fi

# Bring up interface
log "Bringing up interface $IFACE..."
ip link set "$IFACE" up
sleep 2

# Check if it's a wireless interface
if [[ "$IFACE" == wlan* ]]; then
    # Unblock wifi if blocked
    log "Unblocking WiFi..."
    rfkill unblock wifi

    # Scan for networks
    log "Scanning for wireless networks..."
    iw dev "$IFACE" scan | grep -i ssid

    # Get network details
    read -p "Enter SSID: " SSID
    read -s -p "Enter password: " PASS
    echo

    # Create wpa_supplicant configuration
    log "Creating wpa_supplicant configuration..."
    cat > /etc/wpa_supplicant.conf << EOF
network={
    ssid="$SSID"
    psk="$PASS"
}
EOF
    chmod 600 /etc/wpa_supplicant.conf

    # Connect to network
    log "Connecting to network..."
    wpa_supplicant -B -i "$IFACE" -c /etc/wpa_supplicant.conf
fi

# Get IP via DHCP
log "Requesting IP address..."
dhclient "$IFACE"

# Add DNS if needed
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Test connectivity
if ping -c 1 8.8.8.8 &> /dev/null; then
    log "Network connectivity established"
else
    log "Warning: No network connectivity"
fi

# Detect package manager and install Network Manager
if command -v apt &> /dev/null; then
    log "Using apt package manager..."
    apt update
    apt install -y network-manager network-manager-gnome wpasupplicant wireless-tools ifupdown
elif command -v dnf &> /dev/null; then
    log "Using dnf package manager..."
    dnf install -y NetworkManager NetworkManager-wifi NetworkManager-tui
elif command -v pacman &> /dev/null; then
    log "Using pacman package manager..."
    pacman -Sy networkmanager
fi

# Start and enable NetworkManager
log "Starting NetworkManager service..."
systemctl enable --now NetworkManager

log "Script completed. Check $LOG_FILE for details."
log "Please reboot your system to complete the setup."
