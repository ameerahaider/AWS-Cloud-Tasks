provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-905418229977"
}

resource "aws_s3_bucket" "example" {
  bucket = "ameera-terraform-bucket-${terraform.workspace}"
}