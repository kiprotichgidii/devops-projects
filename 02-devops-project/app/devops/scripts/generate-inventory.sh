#!/bin/bash

# This script generates an Ansible inventory.ini file by querying AWS 
# for the public IPs of the instances spun up by the Auto Scaling Groups.

INVENTORY_FILE="../ansible/inventory.ini"
KEY_PATH="../../../terraform/ansible-key.pem"

echo "Generating Ansible Inventory from ASG instances..."

echo "[webservers]" > $INVENTORY_FILE

# Get Ubuntu instances
UBUNTU_IPS=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=advicemate-ubuntu-asg" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

for ip in $UBUNTU_IPS; do
  if [ "$ip" != "None" ] && [ -n "$ip" ]; then
    echo "ubuntu_server_$ip ansible_host=$ip ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $INVENTORY_FILE
  fi
done

# Get Amazon Linux instances
AMZN_IPS=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=advicemate-amazon-linux-asg" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

for ip in $AMZN_IPS; do
  if [ "$ip" != "None" ] && [ -n "$ip" ]; then
    echo "amazon_linux_server_$ip ansible_host=$ip ansible_user=ec2-user ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $INVENTORY_FILE
  fi
done

echo "Done! Inventory saved to $INVENTORY_FILE"
cat $INVENTORY_FILE
