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
  name_prefix = var.name_prefix
}

module "autoscaling_group" {
  source             = "./modules/autoscaling_group"
  name_prefix        = var.name_prefix
  ami_id             = var.ami_id
  instance_type      = "t2.micro"
  key_name           = var.key_name
  min_size           = 1
  max_size           = 3
  desired_capacity   = 1
  security_group_id  = module.sg.ecs-sg
  public_subnet_ids = module.vpc.public_subnets
  ecs_cluster_name = "${var.name_prefix}-ecs-cluster"
}

//ALB
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.sg.ecs-sg
  public_subnet_ids = module.vpc.public_subnets
  name_prefix       = var.name_prefix
}

module "ecs_cluster" {
  source      = "./modules/ecs_cluster"
  name_prefix = var.name_prefix
}

module "ecs_capacity_provider" {
  source                 = "./modules/ecs_capacityprovider"
  name_prefix            = var.name_prefix
  ecs_cluster_name       = module.ecs_cluster.ecs_cluster_name
  auto_scaling_group_arn = module.autoscaling_group.auto_scaling_group_arn

}

module "ecs_task_definition" {
  source = "./modules/ecs_task_definition"
  name_prefix = var.name_prefix
  cpu = "256"
  memory = "512"
  image = "ameerahaider/simple-python-server:latest"
  region = var.region
}

module "ecs_service" {
  source = "./modules/ecs_service"
  name_prefix = var.name_prefix
  cluster_id = module.ecs_cluster.ecs_cluster_id
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count = 1
  public_subnet_ids = module.vpc.public_subnets
  ecs_security_group_id = module.sg.ecs-sg
  target_group_arn = module.alb.alb_target_group_arn
  capacity_provider_name = module.ecs_capacity_provider.capacity_provider_name
}

/*
//EFS
module "efs" {
  source                = "./modules/efs"
  name_prefix           = var.name_prefix
  private_subnets_ids   = module.vpc.private_subnets
  efs_security_group_id = module.sg.efs-sg
}






*/
