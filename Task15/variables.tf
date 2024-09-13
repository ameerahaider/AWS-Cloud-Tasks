variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type = string
  default = "ameera"
}

variable "region" {
  description = "The region where to deploy the infrastructure"
  type = string
  default = "us-east-1"
}
