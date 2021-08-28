#Create vpc in us-east-1
resource "aws_vpc" "vpc-master" {
  cidr_block = "10.0.0.0/16"
  provider = aws.region-master
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-jenkins"
  }
}

#Create vpc in us-west-2
resource "aws_vpc" "vpc-master-oregon" {
  cidr_block = "192.168.0.0/16"
  provider = aws.region-worker
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-vpc-jenkins"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id = "${aws_vpc.vpc-master.id}"
}

#Create IGW in us-west-2
resource "aws_internet_gateway" "igw-oregon" {
  provider = aws.region-worker
  vpc_id = "${aws_vpc.vpc-master-oregon.id}"
}

#Get all available azs in vpc for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state = "available"
}

#Create subnet 1 in us-east-1
resource "aws_subnet" "subnet-1" {
  provider = aws.region-master
  vpc_id = "${aws_vpc.vpc-master.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${element(data.aws_availability_zones.azs.names, 0)}"
}

#Create subnet 2 in us-east-1
resource "aws_subnet" "subnet-2" {
  provider = aws.region-master
  vpc_id = "${aws_vpc.vpc-master.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${element(data.aws_availability_zones.azs.names, 1)}"
}


#Create subnet 1 in us-west-2
resource "aws_subnet" "subnet-1-oregon" {
  provider = aws.region-worker
  vpc_id = "${aws_vpc.vpc-master-oregon.id}"
  cidr_block = "192.168.1.0/24"
}

#Creating peering connection request from useast1 vpc to uswest2 vpc
resource "aws_vpc_peering_connection" "vpc-peering-request-useast1-to-uswest2" {
  provider = aws.region-master
  vpc_id = "${aws_vpc.vpc-master.id}"
  peer_vpc_id = "${aws_vpc.vpc-master-oregon.id}"
  peer_region = "${var.region-worker}"
  tags = {
    Name = "from-mastervpc-to-worker-vpc"
  }
}

#Accepting peering connection request from useast1 in uswest2
resource "aws_vpc_peering_connection_accepter" "vpc-peering-accept-usest1" {
  provider = aws.region-worker
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peering-request-useast1-to-uswest2.id}"
  auto_accept = true
  tags = {
    Name = "from-mastervpc-to-workervpc-acceptor"
  }
}

#Create a route table in us-east-1
resource "aws_route_table" "internet-main-route-table" {
  vpc_id = "${aws_vpc.vpc-master.id}"
  provider = aws.region-master
  #Create inline route to connect to internet via igw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  #Create inline route to connect to other vpc in us-west-2 using vpc peering
  route {
    #The cidr block range of public subnet created in us-west-2 vpc
    cidr_block = "${aws_subnet.subnet-1-oregon.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peering-request-useast1-to-uswest2.id}"
  }
  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = "master-region-route-table"
  }
}

#Route table association to aws_route_table.internet-route. This is necessary because when the vpc was created earlier,
#aws creates a default route table and attaches it to that vpc. Instead we want the vpcs we created to be attached to
#the route tables we create with our configurations. Pls note this is a main route table and not a subnet level route table
#https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
resource "aws_main_route_table_association" "internet-main-route-table-assc" {
  provider = aws.region-master
  route_table_id = "${aws_route_table.internet-main-route-table.id}"
  vpc_id = "${aws_vpc.vpc-master.id}"
}

#Create a route table in us-west-2
resource "aws_route_table" "internet-main-route-table-oregon" {
  vpc_id = "${aws_vpc.vpc-master-oregon.id}"
  provider = aws.region-worker
  #Create inline route to connect to internet via igw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-oregon.id}"
  }
  #Create inline route to connect to other vpc in us-east-1 using vpc peering
  route {
    #The cidr block range of public subnet created in us-east-1 vpc
    cidr_block = "${aws_subnet.subnet-1.cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc-peering-request-useast1-to-uswest2.id}"
  }
  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = "worker-region-route-table"
  }
}

resource "aws_main_route_table_association" "internet-main-route-table-assc-oregon" {
  provider = aws.region-worker
  route_table_id = "${aws_route_table.internet-main-route-table-oregon.id}"
  vpc_id = "${aws_vpc.vpc-master-oregon.id}"
}