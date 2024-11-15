#!/bin/bash

# ATTRIBUTION: ChatGPT o1-preview 2024-11-13 .


# Define the port to forward
PORT=11434

# Retrieve the IP address of the docker0 interface
DOCKER_BRIDGE_IP=$(ip -4 addr show docker0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | tr -dc '0-9.')

# Check if the IP was retrieved successfully
if [ -z "$DOCKER_BRIDGE_IP" ]; then
    echo "Failed to retrieve the IP address of docker0 interface."
    exit 1
fi

# Run socat
exec socat TCP-LISTEN:${PORT},bind=${DOCKER_BRIDGE_IP},fork TCP:127.0.0.1:${PORT}
