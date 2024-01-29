#!/bin/bash

#### Prerequisite ####
# 1. User must be created beforehand
# 2. Make sure to chmod +x this file
# 3. Run this with: ./<filename>.sh <user>

# Script to create an SSH key pair for an existing user and share public key

# Check if user provided a username
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username=$1
user_home="/home/$username"
ssh_dir="$user_home/.ssh"
authorized_keys="$ssh_dir/authorized_keys"

# Check if the user exists
if ! id "$username" &>/dev/null; then
    echo "User $username does not exist."
    exit 1
fi

# Generate SSH key pair
sudo -u "$username" ssh-keygen -t rsa -b 2048 -f "$ssh_dir/id_rsa" -N ""

# List of server addresses
# Replace server with IP for target and user with target user
server_address=("server-1" "server-2")
server_user="ubuntu"

ssh_key=$(sudo cat $user_home/.ssh/id_rsa.pub)
# Loop through server addresses and add the public key to each server
for server_address in "${server_address[@]}"; do
    echo "Processing server: $server_address"
    ssh $server_user@$server_address "echo '$ssh_key' >> ~/.ssh/authorized_keys"
    echo "Public key added to the server $server_address's authorized_keys file."
done


echo "SSH key pair created and shared successfully with all servers."
