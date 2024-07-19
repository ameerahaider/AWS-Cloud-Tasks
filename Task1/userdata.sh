#!/bin/bash

# Update the system
sudo yum update -y

# Install MariaDB server
sudo amazon-linux-extras enable mariadb10.5
sudo yum install -y mariadb-server

# Start and enable MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Configure MariaDB to listen on all IP addresses
sudo sed -i '/bind-address/c\bind-address = 0.0.0.0' /etc/my.cnf

# Restart MariaDB service to apply changes
sudo systemctl restart mariadb

# Create a database and user for the web application
sudo mysql -u root <<EOF
CREATE DATABASE ${db_name};
CREATE USER '${db_username}'@'%' IDENTIFIED BY '${db_password}';
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_username}'@'%';
FLUSH PRIVILEGES;
exit;
EOF

# Update the system again (optional, remove if unnecessary)
# sudo yum update -y

# Install Apache web server and PHP 7
sudo amazon-linux-extras enable php7.4
sudo yum install -y httpd php php-mysqlnd

# Start and enable Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

# Download and install WordPress
cd /var/www/html
sudo wget -c https://wordpress.org/latest.tar.gz -O - | sudo tar -xz

# Move WordPress files to the root directory
sudo mv wordpress/* .
sudo rmdir wordpress

# Set permissions for Apache
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Configure WordPress
sudo cp wp-config-sample.php wp-config.php

# Replace the database configuration values
sudo sed -i "s/database_name_here/${db_name}/" wp-config.php
sudo sed -i "s/username_here/${db_username}/" wp-config.php
sudo sed -i "s/password_here/${db_password}/" wp-config.php

# Restart Apache to apply changes
sudo systemctl restart httpd
