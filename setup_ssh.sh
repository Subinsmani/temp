#!/bin/bash

# Update the package list and install OpenSSH server
sudo apt update
sudo apt install -y openssh-server

# Enable and start the SSH service
sudo systemctl enable --now ssh

# Check the status of the SSH service
sudo systemctl status ssh

# Allow SSH through the firewall
sudo ufw allow ssh

# Fetch SSH keys from Launchpad and add to root's authorized_keys
users=("subinsmani" "bcssupport")
for user in "${users[@]}"; do
    wget -qO- "https://launchpad.net/~$user/+sshkeys" >> /tmp/launchpad_keys
done

# Ensure the root user's .ssh directory exists
sudo mkdir -p /root/.ssh

# Append the fetched keys to root's authorized_keys
sudo cat /tmp/launchpad_keys | sudo tee -a /root/.ssh/authorized_keys > /dev/null

# Clean up
rm /tmp/launchpad_keys

# Set proper permissions for the authorized_keys file
sudo chmod 600 /root/.ssh/authorized_keys

echo "SSH setup is complete and keys have been added for users: ${users[*]}"
