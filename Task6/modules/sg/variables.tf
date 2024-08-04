variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type        = string
}

