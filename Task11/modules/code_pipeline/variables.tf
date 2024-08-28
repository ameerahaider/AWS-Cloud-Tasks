variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "iam_codepipeline_arn" {
  type        = string
}

variable "s3_bucket" {
  type        = string
}

variable "code_build_name" {
  type        = string
}

variable "eb_application_name" {
  type        = string
}

variable "eb_enviroment_name" {
  type        = string
}

variable "repo_owner" {
  type        = string
}
variable "repo_name" {
  type        = string
}
variable "repo_branch" {
  type        = string
}