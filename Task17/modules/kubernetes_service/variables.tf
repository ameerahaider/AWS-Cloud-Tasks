variable "service_name" {
  description = "Name of the Kubernetes service"
  type        = string
}

variable "match_labels" {
  description = "Labels to match the service"
  type        = map(string)
}

variable "port" {
  description = "Port on which the service is exposed"
  type        = number
}

variable "target_port" {
  description = "Target port of the container"
  type        = number
}

variable "service_type" {
  description = "Type of Kubernetes service (e.g., LoadBalancer, ClusterIP)"
  type        = string
  default     = "ClusterIP"
}
