#!/bin/bash
#how to run
#git clone https://github.com/jonarihen/scripts.git

# Run this script as root.

# 1. Update All Packages
apt update && apt upgrade -y

# 2. Set Hostname
read -p "Enter the hostname you want here <|8-D : " hostname
hostnamectl set-hostname $hostname
# Replace <Your-Hostname-Here> with your desired hostname


# 3. System Hardening

## Lock fstab
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab

## Disable root login via SSH (Assuming /etc/ssh/sshd_config exists and is the SSH config file)
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Prompt the user for a username
read -p "Enter the username to allow SSH access: " username

# Append the AllowUsers directive to sshd_config
echo "AllowUsers $username" >> /etc/ssh/sshd_config

echo "SSH access is now allowed for user: $username"

## Install and configure Fail2Ban
apt install fail2ban -y
cp /etc/fail2ban/jail.{conf,local}
# Configure /etc/fail2ban/jail.local as needed

## Enable UFW and set basic rules
ufw allow ssh
ufw enable
# Add additional UFW rules as needed

echo "Basic configuration and hardening complete."


# Ask the user if they want to reboot the server
read -p "Do you want to reboot the server now? (yes/no): " answer

# Convert answer to lowercase
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check if the answer is 'yes'
if [ "$answer" == "yes" ]; then
    echo "Rebooting the server..."
    # Use 'reboot' command to reboot the server
    /sbin/reboot
else
    echo "Server will not be rebooted."
    systemctl restart sshd
fi
    