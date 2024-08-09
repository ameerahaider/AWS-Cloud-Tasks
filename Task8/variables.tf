variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type = string
  default = "ameera"
}

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

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "The CIDR blocks for the public subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}