#!/bin/bash

# Update the package list
yum update -y

# Install the ECS agent and other required software
yum install -y amazon-ecs-init

# Start the ECS agent
start ecs

# Set ECS cluster name in /etc/ecs/ecs.config
echo "ECS_CLUSTER=Ameera-ecs-cluster" >> /etc/ecs/ecs.config

# (Optional) Enable ECS container instance IAM roles
# echo "ECS_ENABLE_TASK_IAM_ROLE=true" >> /etc/ecs/ecs.config
# echo "ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true" >> /etc/ecs/ecs.config

# (Optional) Set log level to debug for troubleshooting
# echo "ECS_LOGLEVEL=debug" >> /etc/ecs/ecs.config

# (Optional) Set ECS instance attributes
# echo "ECS_INSTANCE_ATTRIBUTES={\"Name\":\"Value\"}" >> /etc/ecs/ecs.config

# Reboot the instance to ensure the ECS agent is correctly configured
reboot
