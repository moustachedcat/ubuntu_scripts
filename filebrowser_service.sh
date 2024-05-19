#!/bin/bash

# Script to set up FileBrowser as a systemd service
# Ensure the script is run with superuser privileges

SERVICE_FILE="/etc/systemd/system/filebrowser.service"
FILEBROWSER_EXEC="/usr/local/bin/filebrowser"
DATABASE_DIR="/var/lib/filebrowser"
LOG_FILE="/var/log/filebrowser-service-setup.log"

# Function to check if FileBrowser service is running
is_service_running() {
    systemctl is-active --quiet filebrowser
}

# Log the output
exec > >(tee -a $LOG_FILE) 2>&1

# Stop the FileBrowser service if it is running
if is_service_running; then
    echo "$(date) - FileBrowser service is currently running. Stopping the service..."
    sudo systemctl stop filebrowser
fi

# Ensure the FileBrowser binary exists
if [ ! -f "$FILEBROWSER_EXEC" ]; then
    echo "$(date) - FileBrowser binary not found at $FILEBROWSER_EXEC. Please ensure FileBrowser is installed."
    exit 1
fi

# Create the directory for the database if it does not exist
if [ ! -d "$DATABASE_DIR" ]; then
    echo "$(date) - Creating directory $DATABASE_DIR for the FileBrowser database..."
    sudo mkdir -p $DATABASE_DIR
    sudo chown nobody:nogroup $DATABASE_DIR
fi

# Create the systemd service file
echo "$(date) - Creating systemd service file for FileBrowser..."

cat <<EOL | sudo tee $SERVICE_FILE
[Unit]
Description=FileBrowser
After=network.target

[Service]
Type=simple
ExecStart=$FILEBROWSER_EXEC -r / -a 0.0.0.0 -p 8081 --database $DATABASE_DIR/filebrowser.db
Restart=on-failure
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
EOL

# Reload the systemd daemon to recognize the new service
echo "$(date) - Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the FileBrowser service to start at boot
echo "$(date) - Enabling FileBrowser service to start at boot..."
sudo systemctl enable filebrowser

# Start the FileBrowser service
echo "$(date) - Starting FileBrowser service..."
sudo systemctl start filebrowser

# Check the status of the FileBrowser service
echo "$(date) - Checking the status of FileBrowser service..."
sudo systemctl status filebrowser --no-pager

if is_service_running; then
    echo "$(date) - FileBrowser service setup complete. It is now running on port 8081 and enabled to start at boot."
else
    echo "$(date) - Failed to start FileBrowser service. Check the logs for more details."
fi
