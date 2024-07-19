# AWS EC2 WordPress Deployment with Terraform

## Objective

Provision an EC2 instance on AWS using Terraform, install WordPress, set up a MySQL database on the instance, and configure WordPress to use that MySQL database. This setup should utilize a user data script for automation.

## Output

Upon successful execution of this project, you will have:
- An AWS VPC with the necessary subnets and route tables.
- An EC2 instance running Amazon Linux 2 with Apache, PHP, MySQL, and WordPress installed.
- A MySQL database configured for WordPress.
- A security group allowing HTTP (port 80), MySQL (port 3306), and SSH (port 22) access.
- The public IP address of the EC2 instance outputted for accessing the WordPress setup page.

## Architecture Diagram
[Architecture Diagram](./Diagrams/architectureDiagram.png)

## Project Structure

### Modules

#### VPC

- **main.tf**: Defines the VPC, Internet Gateway, Route Tables, and Subnet.
- **variables.tf**: Contains variables for VPC CIDR, name prefix, availability zones, and subnets. Modify these accoring to your requirements.
- **outputs.tf**: Outputs VPC ID, subnet IDs, and Internet Gateway ID.

#### Security Group

- **main.tf**: Defines the security group allowing HTTP, MySQL, and SSH access.
- **variables.tf**: Contains variables for VPC ID and name prefix.
- **outputs.tf**: Outputs the security group ID.

#### Server

- **main.tf**: Defines the EC2 instance configuration including AMI ID, instance type, key pair, subnet ID, security group ID, and user data script.
- **variables.tf**: Contains variables for AMI ID, instance type, key name, subnet ID, security group ID, and user data.
- **outputs.tf**: Outputs the public IP address of the EC2 instance.

### Main Configuration

- **main.tf**: Configures the AWS provider, invokes the VPC, Security Group, and Server modules, and processes the user data script for server configuration.
- **variables.tf**: Contains the main variables used throughout the project, such as region, instance type, key name, VPC CIDR, subnets, and database credentials.
- **outputs.tf**: Outputs the public IP address of the EC2 instance.

## Explanation of Resources

- **VPC (Virtual Private Cloud)**: A logically isolated section of the AWS cloud where you can launch AWS resources.
- **Subnets**: A range of IP addresses in the VPC.
- **Internet Gateway**: Allows communication between instances in your VPC and the internet.
- **Route Table**: Contains a set of rules, called routes, that are used to determine where network traffic is directed.
- **Security Group**: Acts as a virtual firewall for your instance to control inbound and outbound traffic.
- **EC2 Instance**: A virtual server in Amazon's Elastic Compute Cloud (EC2) for running applications.
- **User Data Script**: A script that runs on the instance at launch to automate the installation and configuration of software (Apache, PHP, MySQL, WordPress).

## CIDR Blocks and IPs

- **VPC CIDR**: 192.168.16.0/20 - Defines a range of IP addresses for the VPC.
- **Subnet CIDR**: 192.168.16.0/24 - Defines a range of IP addresses for the public subnet within the VPC.
  
## Prerequisites

Before running the code, ensure you have the following installed and configured:

1. **Terraform**: Download and install Terraform from [terraform.io](https://www.terraform.io/downloads.html).
2. **AWS CLI**: Install the AWS CLI from [aws.amazon.com/cli](https://aws.amazon.com/cli/) and configure it with your credentials.
   ```bash
   aws configure
   ```

3. **AWS Account**: Ensure you have an AWS account with the necessary permissions to create and manage resources.

4. **SSH Key Pair**: Create an SSH key pair in the AWS Management Console or use an existing one. Make sure the private key is accessible on your local machine.

## Running the Code

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
    ```

2. **Initialize Terraform**:
    ```bash
    terraform init
    ```

3. **Plan the Deployment**:
    ```bash
    terraform plan
    ```

3. **Apply the Deployment**:
    ```bash
    terraform apply
    ```

4. **Access WordPress**:
   - Note the public IP address output by Terraform.
   - Open your web browser and navigate to 
    ```bash
    http://<public-ip>
    ```
   - Follow the WordPress setup instructions.


