module "common-vpc" {
  source = "../modules/common/vpc"
}

module "common-public-subnet" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "${module.common-vpc.this_vpc_cidr_block}"
  az = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "vetrisplayground-public-subnet"
  }
}