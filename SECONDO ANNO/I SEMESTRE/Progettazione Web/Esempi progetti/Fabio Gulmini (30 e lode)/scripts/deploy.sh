#!/bin/bash

# Define the source and destination directories
PROJECT_DIR=$(pwd)
XAMPP_DIR=/opt/lampp/htdocs/life

# Ensure the script is run with sudo, as we need to modify XAMPP files
if [ "$(id -u)" -ne "0" ]; then
    echo "This script requires sudo privileges. Please run as root."
    exit 1
fi

# Remove the existing life folder in the XAMPP directory (if it exists)
echo "Removing existing life folder in XAMPP directory (if exists)..."
rm -rf "$XAMPP_DIR"

# Copy the project directory into the XAMPP directory
echo "Copying project folder to XAMPP's htdocs directory..."
cp -r "$PROJECT_DIR" /opt/lampp/htdocs/

# Change ownership and permissions of the copied project folder
echo "Setting correct permissions and ownership..."
chown -R www-data:www-data "$XAMPP_DIR"
chmod -R 755 "$XAMPP_DIR"

# Restart Apache to apply changes
echo "Restarting Apache server..."
/opt/lampp/lampp reload

echo "Deployment completed successfully!"

# Path to the PHP error log
LOG_FILE="/opt/lampp/logs/php_error_log"

# Watch the log file for new entries
watch -n 1 tail -n 20 "$LOG_FILE"

echo "" > "$LOG_FILE"
