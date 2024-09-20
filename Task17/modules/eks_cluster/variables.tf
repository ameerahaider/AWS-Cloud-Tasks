variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "eks_cluster_role_arn" {
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}


