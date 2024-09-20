variable "region" {
  description = "The region where to deploy the infrastructure"
  type = string
  default = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones for subnet association"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type = string
  default = "ame"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type = string
  default = "192.168.0.0/16"
}

variable "public_subnets" {
  description = "The CIDR blocks for the public subnets"
  type = list(string)
  default = ["192.168.64.0/18", "192.168.128.0/18", "192.168.192.0/18"]
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
  default     = "Ameera-Key-Pair"
}
