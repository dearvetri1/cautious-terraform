module "common-vpc" {
  source = "../modules/common/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}