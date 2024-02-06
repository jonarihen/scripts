#!/bin/bash

# Run this script with sudo privileges

# 1. Networking
ip addr add <Your-IP-Here>/24 dev <Your-Interface-Here>
ip route add default via <Your-Gateway-Here>
# Replace <Your-IP-Here>, <Your-Netmask-Here>, and <Your-Gateway-Here> with actual values. 
# For permanent configuration, you'll need to edit /etc/network/interfaces or netplan configs depending on your Ubuntu version

# 2. Set Hostname
read -p "Enter the hostname you want here <|8-D : " hostname
hostnamectl set-hostname $hostname
# Replace <Your-Hostname-Here> with your desired hostname

# 3. Update All Packages
apt update && apt upgrade -y

# 4. System Hardening

## Lock fstab
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab

## Disable root login via SSH (Assuming /etc/ssh/sshd_config exists and is the SSH config file)
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Prompt the user for a username
read -p "Enter the username to allow SSH access: " username

# Append the AllowUsers directive to sshd_config
echo "AllowUsers $username" >> /etc/ssh/sshd_config

# Restart the SSH service to apply changes
systemctl restart sshd

echo "SSH access is now allowed for user: $username"

## Install and configure Fail2Ban
apt install fail2ban -y
cp /etc/fail2ban/jail.{conf,local}
# Configure /etc/fail2ban/jail.local as needed

## Enable UFW and set basic rules
ufw enable
ufw allow ssh
# Add additional UFW rules as needed

echo "Basic configuration and hardening complete."
#!/bin/bash

# Run this script with sudo privileges

# 1. Networking
ip addr add <Your-IP-Here>/24 dev <Your-Interface-Here>
ip route add default via <Your-Gateway-Here>
# Replace <Your-IP-Here>, <Your-Netmask-Here>, and <Your-Gateway-Here> with actual values. 
# For permanent configuration, you'll need to edit /etc/network/interfaces or netplan configs depending on your Ubuntu version

# 2. Set Hostname
read -p "Enter the hostname you want here <|8-D : " hostname
hostnamectl set-hostname $hostname
# Replace <Your-Hostname-Here> with your desired hostname

# 3. Update All Packages
apt update && apt upgrade -y

# 4. System Hardening

## Lock fstab
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab

## Disable root login via SSH (Assuming /etc/ssh/sshd_config exists and is the SSH config file)
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Prompt the user for a username
read -p "Enter the username to allow SSH access: " username

# Append the AllowUsers directive to sshd_config
echo "AllowUsers $username" >> /etc/ssh/sshd_config

# Restart the SSH service to apply changes
systemctl restart sshd

echo "SSH access is now allowed for user: $username"

## Install and configure Fail2Ban
apt install fail2ban -y
cp /etc/fail2ban/jail.{conf,local}
# Configure /etc/fail2ban/jail.local as needed

## Enable UFW and set basic rules
ufw enable
ufw allow ssh
# Add additional UFW rules as needed

echo "Basic configuration and hardening complete."
