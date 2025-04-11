#!/bin/bash

# Ensure the script is run with sudo, as we need to modify XAMPP files
if [ "$(id -u)" -ne "0" ]; then
    echo "This script requires sudo privileges. Please run as root."
    exit 1
fi

# XAMPP restart command
XAMPP_RELOAD_CMD="sudo /opt/lampp/lampp start"
