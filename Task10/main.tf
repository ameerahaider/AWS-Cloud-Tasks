provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-905418229977"
}

module "s3" {
  source          = "./modules/s3_elasticbeanstalk"
  bucket_name     = var.bucket_name
  app_source_dir  = "./simple-nodejs-app/"
  app_output_path = "simple-nodejs-app.zip"
  object_key      = "nodejs-app.zip"
}

module "application" {
  source        = "./modules/elasticbeanstalk_application"
  name_prefix   = var.name_prefix
  s3_bucket_id  = module.s3.s3_bucket_id
  s3_object_key = module.s3.s3_object_key
}

module "environment" {
  source                      = "./modules/elasticbeanstalk_enviroment"
  name_prefix                 = var.name_prefix
  eb_application_name         = module.application.application_name
  eb_application_version_name = module.application.application_version_name
  solution_stack_name         = "64bit Amazon Linux 2023 v6.2.0 running Node.js 20"
}