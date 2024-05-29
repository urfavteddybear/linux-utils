#!/bin/bash

# Prompt the user for the port number
read -p "Enter port: " port

# Check if the port is a number and within the valid range
if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 0 ] || [ "$port" -gt 65535 ]; then
  echo "Invalid port. Please enter a number between 0 and 65535."
  exit 1
fi

# Prompt the user for the protocol
read -p "Enter protocol [tcp/udp]: " protocol

# Check if the protocol is provided
if [[ -z "$protocol" ]]; then
  echo "Protocol must be provided."
  exit 1
fi

# Validate the protocol input
if [[ "$protocol" != "tcp" && "$protocol" != "udp" ]]; then
  echo "Invalid protocol. Please enter 'tcp' or 'udp'."
  exit 1
fi

# Execute the firewall-cmd commands
sudo firewall-cmd --permanent --zone=public --add-port=${port}/${protocol}
sudo firewall-cmd --reload

# Confirm the changes
if [ $? -eq 0 ]; then
  echo "Port ${port}/${protocol} added successfully and firewall reloaded."
else
  echo "Failed to add port ${port}/${protocol}."
fi
