# Offline Network Recovery Guide

This guide explains how to recover network connectivity when you don't have internet access.

## Using Live USB Method

### 1. Preparation

1. On a working computer:
   - Download a Linux live USB image
   - Create bootable USB using tools like Etcher or dd
   - Download required packages and dependencies:
     ```bash
     apt download network-manager network-manager-gnome wpasupplicant wireless-tools
     ```

2. Copy packages to a separate USB drive

### 2. Booting from Live USB

1. Insert live USB and boot from it
2. Select "Try Ubuntu" (or equivalent)
3. Mount your system drive:
   ```bash
   sudo fdisk -l  # Identify your system partition
   sudo mount /dev/sdaX /mnt  # Replace X with correct partition
   ```

### 3. Chroot Process

```bash
# Mount essential directories
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys

# Copy resolv.conf for DNS
sudo cp /etc/resolv.conf /mnt/etc/resolv.conf

# Enter chroot environment
sudo chroot /mnt

# Now you're in your system
```

### 4. Package Installation

```bash
# If you have the packages on USB:
mount /dev/sdb1 /media/usb  # Mount USB with packages
cd /media/usb
dpkg -i *.deb

# Or if you have internet in live environment:
apt update
apt install network-manager
```

### 5. Service Configuration

```bash
systemctl enable NetworkManager
systemctl start NetworkManager
```

### 6. Cleanup and Reboot

```bash
# Exit chroot
exit

# Unmount everything
sudo umount /mnt/dev
sudo umount /mnt/proc
sudo umount /mnt/sys
sudo umount /mnt

# Reboot
sudo reboot
```

## Manual Package Transfer Method

### 1. Package Download

On a working system:
```bash
# Create package directory
mkdir network-packages
cd network-packages

# Download packages and dependencies
apt download network-manager
apt download network-manager-gnome
apt download wpasupplicant
apt download wireless-tools

# Get dependencies
apt-cache depends network-manager | grep Depends | awk '{print $2}' | xargs apt download
```

### 2. Transfer Process

1. Copy all downloaded .deb files to USB drive
2. On target system:
   ```bash
   # Mount USB
   sudo mount /dev/sdX1 /mnt/usb

   # Install packages
   cd /mnt/usb
   sudo dpkg -i *.deb
   ```

### 3. Configuration

After installation:
```bash
# Start services
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Configure network
nmcli device wifi list
nmcli device wifi connect SSID password PASSWORD
```

## Emergency Network Access

### Using Android USB Tethering

1. Enable USB debugging on Android
2. Connect phone via USB
3. Enable USB tethering
4. On Linux:
   ```bash
   ip link set usb0 up
   dhclient usb0
   ```

### Using iPhone USB Tethering

1. Connect iPhone via USB
2. Trust the computer on iPhone
3. Enable Personal Hotspot
4. On Linux:
   ```bash
   ip link set enp0s20f0u1 up
   dhclient enp0s20f0u1
   ```

## Tips and Best Practices

1. Always keep a backup of:
   - Network configuration files
   - Essential packages
   - Live USB with networking tools

2. Document your network settings:
   - SSID and password
   - Static IP configurations
   - DNS servers

3. Test recovery procedures in VM:
   - Practice chroot process
   - Verify package dependencies
   - Document steps that work
