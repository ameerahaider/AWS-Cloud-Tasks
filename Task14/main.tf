provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-905418229977"
}

module "sg" {
  source      = "./modules/sg"
  name_prefix = var.name_prefix
}


module "iam" {
  source      = "./modules/iam"
  name_prefix = var.name_prefix
}

//Server
module "servers" {
  source                        = "./modules/servers"
  ami_id                        = var.ami_id
  instance_type                 = var.instance_type
  key_name                      = var.key_name
  jenkins_sg_id                 = module.sg.jenkins_sg
  app_sg_id                     = module.sg.app_sg
  name_prefix                   = var.name_prefix
  jenkins_instance_profile_name = module.iam.jenkins_instance_profile_name
}
