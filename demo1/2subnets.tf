#Create 2 public subnets and 2 private subnets in the VPC created in step 1

module "main-public-1" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "10.0.1.0/24"
  az = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

module "main-public-2" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "10.0.2.0/24"
  az = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

module "main-private-1" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "10.0.3.0/24"
  az = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-1"
  }
}

module "main-private-2" {
  source = "../modules/common/public-subnet"
  vpc_id = "${module.common-vpc.this_vpc_id}"
  cidr = "10.0.4.0/24"
  az = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-2"
  }
}