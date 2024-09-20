# EKS Cluster Deployment with Terraform and Kubernetes

This guide provides a detailed step-by-step process for deploying an Amazon EKS (Elastic Kubernetes Service) cluster using Terraform, and configuring Kubernetes resources like deployments and services. This README includes information on Terraform modules used, Kubernetes resources, and how to deploy and destroy the infrastructure.

## Prerequisites

Before you start, ensure you have the following:

1. **AWS Account**: [Sign up for an AWS account](https://aws.amazon.com/) if you don’t have one.
2. **IAM User**: Create an IAM user with permissions to manage EKS, EC2, and networking services. Use the `AdministratorAccess` policy for simplicity in this guide.

## Overview

This setup involves the following main components:
- **Terraform Modules**: Used to define and provision the infrastructure on AWS, including the VPC, IAM roles, EKS cluster, and EKS node group.
- **Kubernetes Modules**: Used to define and deploy Kubernetes resources like deployments and services.

## Terraform Modules

### 1. **VPC Module**
- **Purpose**: Creates a Virtual Private Cloud (VPC) along with subnets, route tables, and internet gateways.
- **Directory**: `modules/vpc`
- **Key Variables**:
  - `vpc_cidr`: CIDR block for the VPC.
  - `availability_zones`: List of availability zones for the VPC.
  - `public_subnets`: List of CIDR blocks for public subnets.

### 2. **Security Group Module**
- **Purpose**: Creates security groups to control inbound and outbound traffic to the EKS nodes.
- **Directory**: `modules/sg`
- **Key Variables**:
  - `vpc_id`: ID of the VPC to associate with the security groups.
  - `name_prefix`: Prefix for naming the security groups.

### 3. **IAM Module**
- **Purpose**: Creates IAM roles and policies required by EKS and the worker nodes.
- **Directory**: `modules/iam`
- **Key Variables**:
  - `name_prefix`: Prefix for naming IAM roles.

### 4. **EKS Cluster Module**
- **Purpose**: Provisions an EKS cluster and outputs necessary information such as cluster name and endpoint.
- **Directory**: `modules/eks_cluster`
- **Key Variables**:
  - `eks_cluster_role_arn`: ARN of the IAM role for the EKS cluster.
  - `subnet_ids`: List of subnet IDs to associate with the EKS cluster.

### 5. **EKS Node Group Module**
- **Purpose**: Creates a node group for the EKS cluster, defining instance types, scaling configuration, and SSH key for access.
- **Directory**: `modules/eks_node_group`
- **Key Variables**:
  - `cluster_name`: Name of the EKS cluster.
  - `node_instance_role_arn`: ARN of the IAM role for the worker nodes.
  - `subnet_ids`: List of subnet IDs for the node group.
  - `instance_type`: Type of EC2 instances to use.
  - `ssh_key_name`: Name of the SSH key pair for accessing the instances.

### 6. **Kubernetes Deployment Module**
- **Purpose**: Defines a Kubernetes deployment resource.
- **Directory**: `modules/kubernetes_deployment`
- **Key Variables**:
  - `deployment_name`: Name of the Kubernetes deployment.
  - `replicas`: Number of replicas for the deployment.
  - `match_labels`: Labels to match the deployment.
  - `container_image`: Docker image for the deployment.
  - `container_name`: Name of the container.
  - `container_port`: Port the container listens on.

### 7. **Kubernetes Service Module**
- **Purpose**: Defines a Kubernetes service resource.
- **Directory**: `modules/kubernetes_service`
- **Key Variables**:
  - `service_name`: Name of the Kubernetes service.
  - `match_labels`: Labels to match the service.
  - `port`: Port on which the service is exposed.
  - `target_port`: Target port of the container.
  - `service_type`: Type of Kubernetes service (e.g., LoadBalancer, ClusterIP).

## Steps to Deploy Infrastructure
### Clone the Repository

First, clone the repository to your local machine:

```sh
git clone https://github.com/ameerahaider/Cloudelligent-Tasks.git
```

Navigate to the project directory:

```sh
cd Task17
```

### Configure AWS CLI

Ensure your AWS CLI is configured with the necessary profile:

```sh
aws configure
```

### Initialize Terraform

Initialize Terraform in your project directory:

```sh
terraform init
```

### Apply Terraform Configuration

Deploy the infrastructure by applying the Terraform configuration:

```sh
terraform apply
```

Confirm the changes by typing 'yes' when prompted.

### Cleanup

To destroy the resources created by Terraform, run:

```sh
terraform destroy
```

Type 'yes' when prompted to confirm the destruction.