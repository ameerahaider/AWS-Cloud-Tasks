variable "name_prefix" {
  description = "The prefix to use for all resource names"
  type = string
}

variable "public_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "efs_sg" {
  description = "Security group ID for EFS mount targets"
  type        = string
}
