variable "region" {
  description = "The region where to deploy the infrastructure"
  type = string
  default = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones for subnet association"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "The CIDR blocks for the public subnets"
  type = list(string)
  default = ["192.168.16.0/24", "192.168.17.0/24"]
}

variable "ami_id" {
  description = "AMI of Linux 2"
  type        = string
  default     = "ami-03972092c42e8c0ca"
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

