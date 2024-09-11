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

variable "ami_id" {
  description = "AMI of Ubuntu"
  type        = string
  default     = "ami-0a0e5d9c7acc336f1"
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
