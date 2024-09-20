provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-905418229977"
}

provider "kubernetes" {
  host                   = module.eks_cluster.endpoint            
  cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
  }
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  name_prefix        = var.name_prefix
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
}

module "sg" {
  source      = "./modules/sg"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
}

module "iam" {
  source      = "./modules/iam"
  name_prefix = var.name_prefix
}

module "eks_cluster" {
  source               = "./modules/eks_cluster"
  name_prefix          = var.name_prefix
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  subnet_ids           = module.vpc.public_subnet_ids

}

module "eks_node_group" {
  source                 = "./modules/eks_node_group"
  name_prefix            = var.name_prefix
  cluster_name           = module.eks_cluster.cluster_name
  node_instance_role_arn = module.iam.eks_worker_node_role_arn
  subnet_ids             = module.vpc.public_subnet_ids
  instance_type          = "t2.micro"
  ssh_key_name           = var.key_name
  node_instance_sg       = module.sg.node-instance-sg-id
}


# Kubernetes Deployment Module
module "nginx_deployment" {
  source          = "./modules/kubernetes_deployment"
  deployment_name = "nginx-deployment"
  replicas        = 2
  match_labels    = { app = "nginx" }
  container_image = "nginx:latest"
  container_name  = "nginx"
  container_port  = 80
}

# Kubernetes Service Module
module "nginx_service" {
  source        = "./modules/kubernetes_service"
  service_name  = "nginx-service"
  match_labels  = { app = "nginx" }
  port          = 80
  target_port   = 80
  service_type  = "LoadBalancer"
}
