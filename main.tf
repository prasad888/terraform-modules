provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  region              = var.region
  name                = var.name
  cidr_block          = var.cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
  envname             = var.envname
}

module "instance" {
  source = "./modules/instance"

  region    = var.region
  name      = var.name
  envname   = var.envname
  ami       = var.ami
  type      = var.type
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
}
