#!/bin/bash

# Folder to watch
WATCH_DIR=$(pwd)

# XAMPP restart command
XAMPP_RELOAD_CMD="sudo /opt/lampp/lampp reload"

# Inotify wait to watch the directory for any changes
inotifywait -m -r -e modify,create,delete,move "$WATCH_DIR" |
while read path action file; do
    echo "Detected change: $file in $path - Action: $action"
    echo "Restarting XAMPP..."
    # Restart XAMPP
    $XAMPP_RELOAD_CMD
done
