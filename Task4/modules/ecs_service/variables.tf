variable "cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Subnet IDs for the ECS Service"
  type        = list(string)
}

variable "main_SG" {
  description = "The ID of the Application Server SG"
  type       = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS Service"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS Service"
  type        = string
}

variable "task_definition_name" {
  description = "Name of the ECS Task Definition"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Docker image to use for the container"
  type        = string
  default     = "nginxdemos/hello"
}
