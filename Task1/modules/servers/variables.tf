variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
}

variable "key_name" {
  description = "The key pair to use for the instances"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the public subnet server"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group for the instances"
  type        = string
}

variable "user_data" {
  description = "User data for instance configuration"
  type        = string
}