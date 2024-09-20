variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "cluster_name" {
  type        = string
}

variable "node_instance_role_arn" {
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "node_instance_sg" {
  type = string
}
