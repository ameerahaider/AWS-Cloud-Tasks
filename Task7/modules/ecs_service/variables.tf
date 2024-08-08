variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "task_definition_arn" {
  description = "Task Definition ARN"
  type        = string
}

variable "ecs_task_sg" {
  description = "Security Group ID for ECS tasks"
  type        = string
}

variable "public_subnet_ids" {
  description = "Private Subnet IDs"
  type        = list(string)
}

variable "capacity_provider_name" {
  type        = string
}

variable "alb_target_group_arn" {
  description = "Target Group ARN"
  type        = string
}

