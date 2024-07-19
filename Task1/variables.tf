variable "region" {
  description = "The region where to deploy the infrastructure"
  type = string
  default = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones for subnet association"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "ami_id" {
  description = "AMI of Linux 2"
  type        = string
  default     = "ami-04823729c75214919"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key Pair Name"
  type        = string
  default     = "Ameera-key"
}

variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type = string
  default = "Ameera"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type = string
  default = "192.168.16.0/20"
}

variable "subnets" {
  description = "The CIDR blocks for the public subnets"
  type = list(string)
  default = ["192.168.16.0/24"]
}

variable "db_name" {
  description = "WordPress database name"
  type        = string
  default = "mydb"
}

variable "db_username" {
  description = "WordPress database username"
  type        = string
  default = "ameera"
}

variable "db_password" {
  description = "WordPress database password"
  type        = string
  default = "12345"
}