FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    iproute2 \
    wireless-tools \
    wpasupplicant \
    network-manager \
    && rm -rf /var/lib/apt/lists/*

# Copy recovery scripts
COPY scripts/restore-nm.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/restore-nm.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/restore-nm.sh"]
