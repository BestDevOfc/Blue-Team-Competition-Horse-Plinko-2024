#!/bin/bash

# Check if service name is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

SERVICE_NAME="$1"
SERVICE_FILE="/lib/systemd/system/$SERVICE_NAME.service"

# Check if the service file exists
if [ ! -f "$SERVICE_FILE" ]; then
  echo "Error: Service file $SERVICE_FILE does not exist."
  exit 1
fi

# Backup the original service file
cp "$SERVICE_FILE" "$SERVICE_FILE.bak"

# Check if the service already has a Restart directive
if grep -q "Restart=" "$SERVICE_FILE"; then
  echo "The service already has a Restart directive. Modifying..."
  sed -i 's/^Restart=.*/Restart=always/' "$SERVICE_FILE"
else
  echo "Adding Restart=always directive to the service."
  # Append the Restart directive in the [Service] section
  sed -i '/^\[Service\]/a Restart=always' "$SERVICE_FILE"
fi

# Reload systemd to apply the changes
systemctl daemon-reload

# Restart the service to ensure it's running with the new configuration
systemctl restart "$SERVICE_NAME"

echo "The $SERVICE_NAME service is now set to automatically restart if killed."
