#!/bin/bash

# The file containing network names, one per line
NETWORK_FILE="networks.txt"

# Check if the file exists
if [ ! -f "$NETWORK_FILE" ]; then
    echo "Error: File $NETWORK_FILE not found."
    exit 1
fi

docker network prune

# Read the file line by line
while IFS= read -r network_name || [[ -n "$network_name" ]]; do
    # Trim whitespace
    network_name=$(echo "$network_name" | tr -d '[:space:]')
    
    # Skip empty lines
    if [ -z "$network_name" ]; then
        continue
    fi
    
    # Check if the network exists
    if docker network inspect "$network_name" >/dev/null 2>&1; then
        echo "Network '$network_name' already exists."
    else
        echo "Creating network: $network_name"
        if docker network create "$network_name"; then
            echo "Network '$network_name' created successfully."
        else
            echo "Failed to create network '$network_name'."
        fi
    fi
done < "$NETWORK_FILE"

echo "Network creation process completed."
