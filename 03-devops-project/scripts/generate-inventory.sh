#!/bin/bash

# This script generates an Ansible inventory.ini file by querying AWS 
# for the public IP of the Jenkins server spun up by Terraform.

INVENTORY_FILE="../ansible/inventory.ini"
KEY_PATH="ansible-key.pem"

echo "Generating Ansible Inventory for Jenkins Server..."

echo "[jenkins]" > $INVENTORY_FILE

# Get Jenkins instance IP
JENKINS_IP=$(aws ec2 describe-instances \
    --filters "Name=tag:Role,Values=jenkins-master" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

if [ "$JENKINS_IP" != "None" ] && [ -n "$JENKINS_IP" ]; then
  echo "jenkins_server ansible_host=$JENKINS_IP ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $INVENTORY_FILE
  echo "Done! Inventory saved to $INVENTORY_FILE with IP: $JENKINS_IP"
else
  echo "Could not find a running Jenkins instance."
  exit 1
fi

# Get Jenkins Agent instance IP
AGENT_IP=$(aws ec2 describe-instances \
    --filters "Name=tag:Role,Values=jenkins-agent" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PublicIpAddress" \
    --output text)

echo "" >> $INVENTORY_FILE
echo "[jenkins_agents]" >> $INVENTORY_FILE

if [ "$AGENT_IP" != "None" ] && [ -n "$AGENT_IP" ]; then
  echo "jenkins_agent ansible_host=$AGENT_IP ansible_user=ubuntu ansible_ssh_private_key_file=$KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $INVENTORY_FILE
  echo "Added agent IP: $AGENT_IP"
else
  echo "Could not find a running Jenkins agent instance."
fi
