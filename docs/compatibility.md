## Distribution Compatibility

This tool has been tested and verified on the following distributions:

### Debian-based Systems
- Ubuntu 22.04 LTS (Full Support)
- Ubuntu 20.04 LTS (Full Support)
- Debian 11 (Full Support)
- Debian 12 (Full Support)

### RPM-based Systems
- Fedora 37+ (Partial Support)
- CentOS 8 Stream (Partial Support)

### Arch-based Systems
- Arch Linux (Basic Support)
- Manjaro (Basic Support)

Package names and commands may vary by distribution. See the distribution-specific guides in `docs/` for details.

## Security Best Practices

1. **Network Security**
   - Always use WPA2/WPA3 encryption when available
   - Avoid connecting to open networks
   - Use strong passwords for network connections

2. **System Security**
   - Keep all network-related packages updated
   - Review network configurations regularly
   - Use secure storage for network credentials

3. **Script Security**
   - Run scripts with minimum required privileges
   - Validate all user inputs
   - Clean up temporary files and configurations

4. **Container Security**
   - Use official base images
   - Keep container images updated
   - Run containers with necessary capabilities only
