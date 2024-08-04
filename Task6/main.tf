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

//IMPORTANT: After ECR creation, add image to repo
/*
Commands to Push image to ECR
# Get AWS repo url from Terraform outputs
$REPO = terraform output --raw ecr_repo_url
$env:REPO = $REPO

# Login to AWS ECR
aws ecr get-login-password --region us-east-1
docker login --username AWS --password YOUR_PASSWORD_HERE REPO_URL_HERE

# Pull docker image & push to our ECR
docker pull --platform linux/amd64 strm/helloworld-http:latest
docker tag strm/helloworld-http:latest REPO_URL_HERE:latest
docker push REPO_URL_HERE:latest
*/

module "cloudwatch" {
  source = "./modules/cloudwatch"
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


