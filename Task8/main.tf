provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-905418229977"
}


module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  name_prefix        = var.name_prefix
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

module "sg" {
  source      = "./modules/sg"
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr
  name_prefix = var.name_prefix

}

module "ecs_cluster" {
  source      = "./modules/ecs_cluster"
  name_prefix = var.name_prefix
}

module "iam" {
  source      = "./modules/iam"
  name_prefix = var.name_prefix
}

module "autoscaling_group" {
  source               = "./modules/autoscaling_group"
  name_prefix          = var.name_prefix
  ecs_node_sg_id       = module.sg.ecs-node-sg
  ecs_node_profile_arn = module.iam.ecs_node_profile_arn
  ecs_cluster_name     = module.ecs_cluster.ecs_cluster_name
  public_subnet_ids    = module.vpc.public_subnets_id
  min_size             = 2
  max_size             = 8
}

module "alb" {
  source            = "./modules/alb"
  name_prefix       = var.name_prefix
  public_subnet_ids = module.vpc.public_subnets_id
  alb-sg            = module.sg.alb-sg
  vpc_id            = module.vpc.vpc_id
}

//EFS
module "efs" {
  source            = "./modules/efs"
  name_prefix       = var.name_prefix
  public_subnet_ids = module.vpc.public_subnets_id
  efs_sg            = module.sg.efs-sg
}

module "ecs_capacity_provider" {
  source                 = "./modules/ecs_capacityprovider"
  name_prefix            = var.name_prefix
  auto_scaling_group_arn = module.autoscaling_group.auto_scaling_group_arn
  ecs_cluster_name       = module.ecs_cluster.ecs_cluster_name

}

module "ecr" {
  source      = "./modules/ecr"
  name_prefix = var.name_prefix
  repo_name   = "ameera-app"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  name_prefix = "Ameera"
}

module "ecs_task_definition" {
  source                 = "./modules/ecs_task_definition"
  name_prefix            = var.name_prefix
  ecs_task_role_arn      = module.iam.ecs_task_arn
  ecs_exec_role_arn      = module.iam.ecs_exec_task_arn
  ecr_repo_url           = module.ecr.ecr_repo_url
  cloud_watch_group_name = module.cloudwatch.cloud_watch_group_name
  efs_id                 = module.efs.efs_id
}

//IMPORTANT: After ECR creation, add image to repo
/*
Commands to Push image to ECR
# Get AWS repo url from Terraform outputs
$REPO = terraform output --raw ecr_repo_url
$env:REPO = $REPO

# Login to AWS ECR
aws ecr get-login-password --region us-east-1
docker login --username AWS --password YOUR_PASSWORD_HERE REPO_URL_HERE
docker login --username AWS --password eyJwYXlsb2FkIjoiNExTbXZKanJnNXZyZUZlc0FTdE5FODlSTlhpcnEraDkxa0hvMHNFTDJnakZXcmdaQ2cvcDZJWVJMMEtSUmJUa1FEYmhlKytRVm5mb3IxSVJrQzkzdFNSdnZGdmhKd3NoOHJOMHByS3JaOEF5RGxMVzU2OU9odUJXUkJsdXJLK1hCQVdXQ3RCOVVjRFphZGluSGhxVWtrWmZJZ0xmSGRkZjdvSTFYQm9rNGFQK1RpMjNpdDl6dDZwV0hSUEt3clRtQytxZ0ZZeDVQcHdrdy9oM1ZITzI2TkU1aGcrRm5CaUcwSnR0aU9mOEV3TWR3Q0ZTaS9NOStyZ3VuL1htb21Va2pud3E5YmFib1o3NHROcEhUQllJQnMyN0l0TjFUTkcvY3djMEtGL1VCZUQ2dWE3dWRJN1ZJSFM2eUNEdDd6dU9HempYWEhRejQ1UHE5Mmg4SU1HQXE5NlRZaTJHWDc1ckhkNnluMnZaZFhiamc4M1lKWFJuLzV1K2lSTEJ1NUdTZ0JvZnN2NDZlZjFFczJxMDFEdlRXMk9jLzl2YzVSd3E1S0lVdkYyVDlHQzVXcUg0MVhMMXh3YVNXRkhPMDJLaFhvMFArL0xhcGFTVXZvZWdWZGhkczgxaXp0OTA3TWhvbEkvNkN4Uk9xZmptOUJPUU9uQThGNzQvemM1V0xud3JpYkFFM1ZxYnQ1bnNTT0JscDR3YXNGUkFUZCs1QnhOYVFhMFVyOU1RMWZPWm9kd0RzOEkraGlvQU1VNVVwbzJaanhQYXhTTVZDbm1BTkZGeTJlTjhLNTJ0OGIrUzM1WUlUbXdYZ1NlZC9aN0lPbStiK21pbzVGOEd6SmR5Zkh4WWJTcFNPcjlaN0M4SktyYUtTM2svaXN6Qm1MSERHRElZY1ZieCtvbG5EbUpEVndOZGtLNGJCcTNJR09aZU1iYk5oUjI0alhUTTIyT3VxeDVTSDE2ZTVLaEFwY3hLMkdMMU5EMlFOVTJyNk56Y3dYdkU5T3Z5QjdHN2RDYlcyUGx3bWcrZ2JNQzFYbEdIaFhNUm5adWVORGdNcWJuaDRLb0tLYTU1RXlLVXJWL1pTVjBhSFIwRTZHYi9XWU9rTmtUR2ZFZkRWQjhqbGJ6Q2JJbVEzTWxzcU5ZRE05VDNJbXJsZUsxempVVGt0VXdWaG5tYzhnUGNTaGZGWngvSDRlZURTaTNTTlJ1eE5HK0R2SXNlbndHMGlld05MSmlNbVNHOUhjK1VnNUdvVUNDblAxcWFpcGt4M2hGcWVndjdaZkNucWVqVFJPUzNpWnZKTlJGM2sxRUcvb20vZEsvaVNhQmxNTHdWbHZuTkFpLzFtRTZIdmxUSi9ob1FXU2Z3UUdRSDBLRDVoWEJ3bkRPTCtSUzBqaDB5ZFdsYVpNOW9hUFZqYkJrNGI2OU5EdmhmNkRNMC9YejRjR09OSlNjcVprOCtmYk54TjJhMHVHUU8rSFhxNUhlWSszWmREaUw0SENNRlFQN2s3cWdRVE9QaG16SjR3MG9DcktoeHpXK0tSbjlXbVpTNVRkS0Yva0E4aEpabmxkaUdKbGgxVTBtN1prdm1adTBGVHRSSExkcnY2NzgzeVJ2clRVZVV5OU85SzRqdEUxNWtwQkRXbDRxaWlJTlVTSFphTjk0a2VGVmM2QlZNUy9KaFAzaHRoWFhuR1FmRWxqRFhkblhRRVdySXFWSXNaVXQ1OVEzN1owSDJza0FSN3Q5bmhCVEd3YXJtZXJ6ZzBIMUE0Uks5S2d0WWY0NVpscjYzSHhwczNjaDlVZmNSaElrbkQ0dz0iLCJkYXRha2V5IjoiQVFFQkFIaHdtMFlhSVNKZVJ0Sm01bjFHNnVxZWVrWHVvWFhQZTVVRmNlOVJxOC8xNHdBQUFINHdmQVlKS29aSWh2Y05BUWNHb0c4d2JRSUJBREJvQmdrcWhraUc5dzBCQndFd0hnWUpZSVpJQVdVREJBRXVNQkVFREVJRTlQc0luek54aXZJQ3F3SUJFSUE3THZhdER1dWN1dG5UcnZVUmI5U2JsaEhaNGUyU2xEYmNNc3R6S01STHZONzVXWHZNS3RMZzJNRkVGNC9vV3MrOThhRzRGeklRSmFxazgzND0iLCJ2ZXJzaW9uIjoiMiIsInR5cGUiOiJEQVRBX0tFWSIsImV4cGlyYXRpb24iOjE3MjI5MDc5Mjd9 905418229977.dkr.ecr.us-east-1.amazonaws.com/ameera-app

# Pull docker image & push to our ECR
docker pull --platform linux/amd64 strm/helloworld-http:latest
docker tag strm/helloworld-http:latest REPO_URL_HERE:latest
docker tag myapp:latest 905418229977.dkr.ecr.us-east-1.amazonaws.com/ameera-app:latest
docker push REPO_URL_HERE:latest
docker push 905418229977.dkr.ecr.us-east-1.amazonaws.com/ameera-app:latest
*/

module "ecs_service" {
  source                 = "./modules/ecs_service"
  name_prefix            = var.name_prefix
  ecs_cluster_id         = module.ecs_cluster.ecs_cluster_id
  task_definition_arn    = module.ecs_task_definition.task_definition_arn
  ecs_task_sg            = module.sg.ecs-task-sg
  public_subnet_ids      = module.vpc.public_subnets_id
  capacity_provider_name = module.ecs_capacity_provider.capacity_provider_name

  alb_target_group_arn = module.alb.alb_target_group_arn
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
}

module "code_pipeline" {
  source               = "./modules/code_pipeline"
  name_prefix          = var.name_prefix
  iam_codepipeline_arn = module.iam_codepipeline.codepipeline_role_arn
  s3_bucket            = module.s3_pipeline.s3_bucket
  code_build_name      = module.code_build.code_build_name
  ecs_cluster_name     = module.ecs_cluster.ecs_cluster_name
  ecs_service_name     = module.ecs_service.ecs_service_name
  repo_owner           = "ameerahaider"
  repo_name            = "simple-web-app"
  repo_branch          = "main"

}



/*
Option 1: Use GitHub as a Source with Version 1
If you want to use GitHub without the new ConnectionArn and stick with the classic approach, you'll need to use a GitHub OAuth token.

Generate a GitHub Personal Access Token:

Go to your GitHub account.
Navigate to Settings > Developer settings > Personal access tokens > Tokens (classic).
Click Generate new token, choose the appropriate scopes (repo and admin:repo_hook), and generate the token.
Save the token securely.
*/

