# Alternative Network Management Solutions

This document outlines alternative network management solutions for Linux systems that can be used instead of NetworkManager.

## systemd-networkd

systemd-networkd is a lightweight network management daemon that's part of systemd. It's especially suitable for servers and minimal installations.

### Setting up systemd-networkd

1. Enable and start the services:
```bash
sudo systemctl enable --now systemd-networkd systemd-resolved
```

2. Create a basic network configuration:
```bash
sudo nano /etc/systemd/network/20-wired.network
```

Add:
```ini
[Match]
Name=eth0

[Network]
DHCP=yes
```

3. Link resolv.conf:
```bash
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

## ConnMan

ConnMan (Connection Manager) is a daemon for managing internet connections within embedded devices running Linux.

### Installing ConnMan

#### On Debian/Ubuntu:
```bash
sudo apt install connman
```

#### On Fedora:
```bash
sudo dnf install connman
```

### Basic ConnMan Usage

1. Start the service:
```bash
sudo systemctl start connman
```

2. Use connmanctl for management:
```bash
connmanctl
enable wifi
scan wifi
services
connect wifi_*
```

## Comparison of Solutions

| Feature | NetworkManager | systemd-networkd | ConnMan |
|---------|---------------|------------------|---------|
| GUI Support | Yes | No | Limited |
| Resource Usage | Higher | Low | Medium |
| Configuration | Easy | Manual | Moderate |
| Best For | Desktop | Server | Embedded |

## Migration Steps

### From NetworkManager to systemd-networkd

1. Backup existing configuration
2. Stop NetworkManager
3. Enable systemd-networkd
4. Create basic configuration
5. Test and verify

### From NetworkManager to ConnMan

1. Export existing connections
2. Install ConnMan
3. Import configurations
4. Test connectivity

## Additional Resources

- [systemd-networkd Documentation](https://www.freedesktop.org/software/systemd/man/systemd-networkd.service.html)
- [ConnMan Project Page](https://01.org/connman)
