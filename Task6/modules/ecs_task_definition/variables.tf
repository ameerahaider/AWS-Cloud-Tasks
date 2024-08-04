variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "ecs_task_role_arn" {
  type        = string
}

variable "ecs_exec_role_arn" {
  type        = string
}

variable "ecr_repo_url" {
  type        = string
}

variable "cloud_watch_group_name" {
  type        = string
}

variable "efs_id" {
  type        = string
}

