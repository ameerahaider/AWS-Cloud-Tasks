# Terraform Workspaces

## Introduction

Terraform workspaces allow you to manage multiple environments (such as development, staging, production) using a single Terraform configuration. Each workspace maintains a separate state file, meaning that resources created in one workspace do not interfere with those in another workspace. This makes it easy to isolate different environments while using the same codebase.

### Why Use Terraform Workspaces?

- **Separate environments**: Easily manage different environments like development, staging, and production without modifying the code.
- **Isolated states**: Each workspace keeps its own state file, avoiding conflicts or overwrites between environments.
- **Reusability**: Use the same configuration for different environments, reducing code duplication and the risk of mistakes.

---

## How Terraform Workspaces Work

Terraform workspaces help you run the same infrastructure as code across different environments. The state file of each workspace is isolated from others, ensuring that changes in one environment (e.g., development) do not affect another (e.g., production).

When you switch between workspaces, Terraform uses a different state file for each workspace. You can also customize resource names and behaviors based on the current workspace by referencing `terraform.workspace`.

---

## Benefits of Terraform Workspaces

1. **Simplified Management**: You can use a single configuration file for multiple environments without creating multiple directories or files.
2. **Isolated State**: Each workspace maintains its own state file, preventing changes in one environment from affecting another.
3. **Consistency Across Environments**: The same code runs in all environments, ensuring that infrastructure remains consistent.
4. **Less Code Duplication**: You don't need to maintain separate configurations for each environment, which reduces the complexity and potential for errors.

---

## Example: Setting Up Terraform Workspaces

This example demonstrates how to use Terraform workspaces to manage multiple environments (development and production).

### Step 1: Create Terraform Configuration

Create a `main.tf` file with the following configuration. It provisions an S3 bucket and includes the workspace name in the bucket's name:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "ameera-terraform-bucket-${terraform.workspace}"
}
```

Here, `${terraform.workspace}` dynamically includes the workspace name in the S3 bucket’s name, ensuring that each environment has its own bucket.

---

### Step 2: Initialize Terraform

Run the following command:

```bash
terraform init
```

---

### Step 3: Create and Switch Between Workspaces

By default, you start in the `default` workspace. You can create new workspaces using the following commands:

#### Create and Switch to Development Workspace

```bash
terraform workspace new development
```

This creates a workspace called `development` and switches to it.

#### Create and Switch to Production Workspace

```bash
terraform workspace new production
```

This creates a workspace called `production` and switches to it.

#### Check Current Workspace

To see which workspace you're currently in, run:

```bash
terraform workspace show
```

---

### Step 4: Apply Infrastructure in Each Workspace

Now you can apply the Terraform configuration in each workspace. The resources created in each workspace are separate and won't interfere with one another.

#### Apply in the Development Workspace

First, switch to the `development` workspace and apply the changes:

```bash
terraform workspace select development
terraform apply
```

This will create an S3 bucket named `ameera-terraform-bucket-development`.

#### Apply in the Production Workspace

Next, switch to the `production` workspace and apply the changes:

```bash
terraform workspace select production
terraform apply
```

This will create a separate S3 bucket named `ameera-terraform-bucket-production`.

---

### Step 5: List and Switch Between Workspaces

You can list all the available workspaces with:

```bash
terraform workspace list
```

To switch between workspaces, use:

```bash
terraform workspace select <workspace-name>
```

### Step 6: Clean Up Resources

When you're done, you can destroy the infrastructure in each workspace.

#### Destroy Resources in the Development Workspace

```bash
terraform workspace select development
terraform destroy
```

#### Destroy Resources in the Production Workspace

```bash
terraform workspace select production
terraform destroy
```

---

### Key Commands

- **Create a Workspace**: `terraform workspace new <workspace-name>`
- **Switch to a Workspace**: `terraform workspace select <workspace-name>`
- **Show Current Workspace**: `terraform workspace show`
- **List All Workspaces**: `terraform workspace list`
  

### Other Concepts of Terraform Workspaces
---

## 1. **Workspace-Specific Variables**

While using workspaces, you often want to have workspace-specific variables that allow you to deploy infrastructure differently across environments. For example, you may want to deploy smaller instances in the `development` workspace and larger instances in the `production` workspace.

To achieve this, you can define variables that behave differently depending on which workspace is selected. Here's how:

### Example: Conditional Variables Based on Workspace

In your `variables.tf` file, you can define variables that change based on the current workspace:

```hcl
variable "environment" {
  type    = string
  default = "development"
}

variable "bucket_name" {
  type    = string
  default = "my-app-bucket-${terraform.workspace}"
}
```

Then, in your `main.tf`, you can use conditional logic to set different values for different workspaces:

```hcl
resource "aws_instance" "example" {
  instance_type = var.environment == "production" ? "t2.large" : "t2.micro"
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}
```

In this case, the `instance_type` will be `t2.large` in production and `t2.micro` in other workspaces, while the S3 bucket name will always include the workspace name.

#### Using Workspace-Specific Variable Files
Another approach is to define separate `.tfvars` files for each workspace and load them dynamically based on the workspace you’re working in. For example:

- `development.tfvars`:

```hcl
instance_type = "t2.micro"
```

- `production.tfvars`:

```hcl
instance_type = "t2.large"
```

When applying Terraform, you can load the corresponding `.tfvars` file based on the current workspace:

```bash
terraform apply -var-file="${terraform.workspace}.tfvars"
```

This is a good way to manage different configurations for each workspace.

---

## 2. **Workspaces and CI/CD Pipelines**

When integrating Terraform workspaces into a CI/CD pipeline, the goal is often to dynamically select the workspace based on the environment. This is useful when you want your CI/CD pipeline to automatically switch between environments for testing, staging, and production deployments.

### Example: Using Workspaces in a CI/CD Pipeline

In a pipeline (e.g., Jenkins, GitLab CI), you can include logic to switch to the correct workspace based on an environment variable or pipeline stage.

#### Sample Jenkins Pipeline (Declarative Syntax)

```groovy
pipeline {
  agent any

  environment {
    WORKSPACE_NAME = "${params.ENVIRONMENT}"
  }

  stages {
    stage('Initialize') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Select Workspace') {
      steps {
        script {
          // Check if the workspace exists
          def workspaceExists = sh(script: "terraform workspace list | grep ${WORKSPACE_NAME}", returnStatus: true)
          if (workspaceExists != 0) {
            // Create the workspace if it doesn't exist
            sh "terraform workspace new ${WORKSPACE_NAME}"
          }
          // Switch to the workspace
          sh "terraform workspace select ${WORKSPACE_NAME}"
        }
      }
    }

    stage('Apply') {
      steps {
        sh "terraform apply -var-file=\"${WORKSPACE_NAME}.tfvars\" -auto-approve"
      }
    }
  }
}
```

In this pipeline, the environment variable `WORKSPACE_NAME` is passed as a parameter, and the pipeline automatically switches to the appropriate Terraform workspace.

#### Benefits:
- **Environment-specific deployments**: Dynamically apply infrastructure changes based on the environment, using workspaces to separate states.
- **Automation**: You don’t need manual intervention to select or create workspaces, as the pipeline handles it.
- **Consistency**: Environments are managed consistently using the same Terraform codebase.

---

## 3. **Workspaces for Multi-Tenancy**

In multi-tenant environments, where you manage infrastructure for multiple clients, Terraform workspaces provide a way to manage separate state files for each tenant. This keeps the resources and states for each client isolated from one another, reducing the risk of cross-tenant access or resource conflicts.

### Example: Multi-Tenant Architecture Using Workspaces

Consider you’re managing infrastructure for multiple clients, each with their own set of resources. You can create a workspace for each tenant:

```bash
terraform workspace new client_a
terraform workspace new client_b
```

In your Terraform configuration, you can use the workspace name to ensure resources are created in isolation for each client. For example:

```hcl
resource "aws_s3_bucket" "client" {
  bucket = "client-data-${terraform.workspace}"
}
```

Each workspace (e.g., `client_a`, `client_b`) will create a separate S3 bucket for that client, ensuring the data remains isolated.

### Advanced Considerations for Multi-Tenancy:
- **State Management**: Each workspace has its own state file, making it easier to isolate tenant data. However, it's important to consider state file security and access control.
- **Scaling**: Workspaces work well for smaller-scale multi-tenancy, but for very large multi-tenant environments, you may need additional strategies such as using different backend storage systems for state files (e.g., different S3 buckets).
- **Cost Control**: You can track and manage costs per tenant more easily because their resources are isolated within a specific workspace.

---

## 4. **Best Practices for Using Terraform Workspaces**

### 4.1. **Limit Workspace Usage for Environments or Tenants**
Workspaces are great for separating environments (dev, prod) or tenants (multi-client environments), but should not be used as a replacement for Terraform modules or separate state management for different infrastructure components. Keep workspace usage limited to well-defined use cases, such as:

- **Environment separation**: dev, staging, prod.
- **Multi-tenancy**: isolated client resources.

For more complex infrastructure, consider separating state using different backend configurations (e.g., different S3 buckets) instead of overloading workspaces.

### 4.2. **Use Backend Locking Mechanisms**
In environments where multiple team members or CI/CD pipelines are working on the same workspace, it’s important to use Terraform’s backend locking mechanisms to avoid conflicts. For example, if you're using S3 as the state backend, enable DynamoDB state locking to ensure that only one process can modify the state at a time:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "state/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
  }
}
```

This prevents race conditions and state corruption when multiple people or processes interact with the same workspace.