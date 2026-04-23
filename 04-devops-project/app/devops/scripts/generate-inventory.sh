#!/bin/bash

# This script generates an Ansible inventory.ini file by querying AWS 
# for the public IPs of the instances spun up by Terraform.

INVENTORY_FILE="../ansible/inventory.ini"
KEY_PATH="ansible-key.pem"

echo "Generating Ansible Inventory from EC2 instances..."

echo "[webservers]" > $INVENTORY_FILE

# Get instances matching the project tag
IPS=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=jenkins-pipeline-web" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

for ip in $IPS; do
  if [ "$ip" != "None" ] && [ -n "$ip" ]; then
    echo "web_server_$ip ansible_host=$ip ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $INVENTORY_FILE
  fi
done

echo "Done! Inventory saved to $INVENTORY_FILE"
cat $INVENTORY_FILE
