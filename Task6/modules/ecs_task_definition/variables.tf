variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "cpu" {
  description = "The number of CPU units used by the task"
  type        = string
}

variable "memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = string
}

variable "image" {
  description = "The Docker image to use for the container"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}
