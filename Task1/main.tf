provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  name_prefix        = var.name_prefix
  availability_zones = var.availability_zones
  subnets            = var.subnets
}

module "sg" {
  source      = "./modules/sg"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
}

//Database Server User Data
data "template_file" "userdata" {
  template = file("./userdata.sh")

  vars = {
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  }
}

//Server
module "servers" {
  source            = "./modules/servers"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.vpc.subnets[0]
  security_group_id = module.sg.main_SG
  user_data         = data.template_file.userdata.rendered
  name_prefix       = var.name_prefix
}
