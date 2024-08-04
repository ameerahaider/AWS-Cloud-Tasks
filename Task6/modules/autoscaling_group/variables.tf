variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "ecs_node_sg_id" {
  description = "ID of the security group for instances"
  type        = string
}

variable "ecs_node_profile_arn" {
  description = "ID of the AMI to use for instances"
  type        = string
}

variable "ecs_cluster_name" {
  type        = string
}

variable "public_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}