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

variable "jenkins_sg_id" {
  type        = string
}

variable "app_sg_id" {
  type        = string
}

variable "jenkins_instance_profile_name" {
  type        = string
}

