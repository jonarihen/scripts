#!/bin/bash
#how to run
#git clone https://github.com/jonarihen/scripts.git

# Run this script as root.


# Update package index
apt update

# Install Apache2

apt install apache2 -y

#Allow Apache trafic into server
ufw allow in "Apache"

# Install MySQL
apt install mysql-server -y

# Install PHP and its extensions required by WordPress
apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Restart Apache to apply PHP installation
systemctl restart apache2

# Create MySQL database and user for WordPress
read -p "What should the DB name be ? : " DBNAME
read -p "What should the username be ? : " DBUSER
read -p "What should the password be ? : " DBPASS

# Replace 'password' with a secure password of your choosing

mysql -e "CREATE DATABASE ${DBNAME};"
mysql -e "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

# Copy WordPress files to the Apache document root
cp -a /tmp/wordpress/. /var/www/html

# Set permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 750 {} \;
find /var/www/html -type f -exec chmod 640 {} \;

# Configure WordPress to connect to the database
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/${DBNAME}/" /var/www/html/wp-config.php
sed -i "s/username_here/${DBUSER}/" /var/www/html/wp-config.php
sed -i "s/password_here/${DBPASS}/" /var/www/html/wp-config.php


# Download WordPress secret keys
wget -O /tmp/wp_keys.txt https://api.wordpress.org/secret-key/1.1/salt/

# Insert the keys into wp-config.php
sed -i '/AUTH_KEY/d' /var/www/html/wp-config.php
sed -i '/SECURE_AUTH_KEY/d' /var/www/html/wp-config.php
sed -i '/LOGGED_IN_KEY/d' /var/www/html/wp-config.php
sed -i '/NONCE_KEY/d' /var/www/html/wp-config.php
sed -i '/AUTH_SALT/d' /var/www/html/wp-config.php
sed -i '/SECURE_AUTH_SALT/d' /var/www/html/wp-config.php
sed -i '/LOGGED_IN_SALT/d' /var/www/html/wp-config.php
sed -i '/NONCE_SALT/d' /var/www/html/wp-config.php
sed -i "/^\/\* That's all, stop editing! Happy publishing. \*\//r /tmp/wp_keys.txt" /var/www/html/wp-config.php

# Clean up
rm /tmp/wp_keys.txt

echo "Secret keys added to wp-config.php."



# Remove the existing index.html file
rm /var/www/html/index.html

# Restart Apache to apply all changes
systemctl restart apache2

echo "LAMP stack and WordPress installed successfully."