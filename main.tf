provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr_block
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
}

module "lb" {
  source = "./modules/lb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  instance_ids = module.ec2.instance_ids
}
