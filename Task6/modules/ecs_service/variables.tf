variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "task_definition_arn" {
  description = "Task Definition ARN"
  type        = string
}

variable "desired_count" {
  description = "Number of desired tasks"
  type        = number
}

variable "ecs_security_group_id" {
  description = "Security Group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}

variable "capacity_provider_name" {
  type        = string
}


variable "public_subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}
