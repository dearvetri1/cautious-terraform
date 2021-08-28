#Create vpc in us-east-1
resource "aws_vpc" "vpc-master" {
  cidr_block = "10.0.0.0/16"
  provider = "aws.region-master"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-jenkins"
  }
}

#Create vpc in us-west-2
resource "aws_vpc" "vpc-master-oregon" {
  cidr_block = "192.168.0.0/16"
  provider = "aws.region-worker"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-vpc-jenkins"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = "aws.region-master"
  vpc_id = "${aws_vpc.vpc-master.id}"
}

#Create IGW in us-west-2
resource "aws_internet_gateway" "igw-oregon" {
  provider = aws.region-worker
  vpc_id = "${aws_vpc.vpc-master-oregon.id}"
}

#Get all available azs in vpc for master region
data "aws_availability_zones" "azs" {
  provider = "aws.region-worker"
}

