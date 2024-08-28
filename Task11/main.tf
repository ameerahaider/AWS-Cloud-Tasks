provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-905418229977"
}

module "application" {
  source        = "./modules/elasticbeanstalk_application"
  name_prefix   = var.name_prefix
}

module "environment" {
  source                      = "./modules/elasticbeanstalk_enviroment"
  name_prefix                 = var.name_prefix
  eb_application_name         = module.application.application_name
  solution_stack_name         = "64bit Amazon Linux 2023 v6.2.0 running Node.js 20"
}


module "s3_pipeline" {
  source      = "./modules/s3_pipeline"
  name_prefix = var.name_prefix
}

module "iam_codebuild" {
  source      = "./modules/iam_codebuild"
  name_prefix = var.name_prefix
}

module "iam_codepipeline" {
  source      = "./modules/iam_codepipeline"
  name_prefix = var.name_prefix
}

module "code_build" {
  source            = "./modules/code_build"
  name_prefix       = var.name_prefix
  iam_codebuild_arn = module.iam_codebuild.codebuild_role_arn
  s3_bucket_name = module.s3_pipeline.s3_bucket
}

module "code_pipeline" {
  source               = "./modules/code_pipeline"
  name_prefix          = var.name_prefix
  iam_codepipeline_arn = module.iam_codepipeline.codepipeline_role_arn
  s3_bucket            = module.s3_pipeline.s3_bucket
  code_build_name      = module.code_build.code_build_name
  eb_application_name     = module.application.application_name
  eb_enviroment_name     = module.environment.environment_name
  repo_owner           = "ameerahaider"
  repo_name            = "simple-nodejs-app"
  repo_branch          = "main"

}