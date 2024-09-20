variable "deployment_name" {
  description = "Name of the Kubernetes deployment"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 1
}

variable "match_labels" {
  description = "Labels to match the deployment"
  type        = map(string)
}

variable "container_image" {
  description = "Docker container image for the deployment"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port that the container listens on"
  type        = number
}
