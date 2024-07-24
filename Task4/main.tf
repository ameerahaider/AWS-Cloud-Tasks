provider "aws" {
  region = var.region
  profile = "AWSAdministratorAccess-905418229977"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  name_prefix        = var.name_prefix
  availability_zones = var.availability_zones
  public_subnets            = var.public_subnets
}

module "sg" {
  source      = "./modules/sg"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
}

module "ecs_cluster" {
  source      = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "ecs_service" {
  source                  = "./modules/ecs_service"
  cluster_id              = module.ecs_cluster.cluster_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  vpc_id                  = module.vpc.vpc_id
  main_SG                 = module.sg.main_SG
  service_name            = "AMEERA-service"
  task_definition_name    = "AMEERA-task"
  container_name          = "AMEERA-container"
  container_image         = "nginx"
}