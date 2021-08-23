resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  tags = {
    name = "main"
  }
}

#public subnets
resource "aws_subnet" "main-public-1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    name = "main-public-2"
  }
}

resource "aws_subnet" "main-public-3" {
  cidr_block              = "10.0.3.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"
  tags = {
    name = "main-public-3"
  }
}

#private subnets
resource "aws_subnet" "main-private-1" {
  cidr_block              = "10.0.4.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    name = "main-private-1"
  }
}

resource "aws_subnet" "main-private-2" {
  cidr_block              = "10.0.5.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    name = "main-private-2"
  }
}

resource "aws_subnet" "main-private-3" {
  cidr_block              = "10.0.6.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"
  tags = {
    name = "main-private-3"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "main"
  }
}

#Route Table
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    name = "main-public-1"
  }
}

#Route table association to pubic subnets

resource "aws_route_table_association" "main-public-1-a" {
  route_table_id = aws_route_table.main-public.id
  subnet_id      = aws_subnet.main-public-1.id
}

resource "aws_route_table_association" "main-public-1-b" {
  route_table_id = aws_route_table.main-public.id
  subnet_id      = aws_subnet.main-public-2.id
}

resource "aws_route_table_association" "main-public-1-c" {
  route_table_id = aws_route_table.main-public.id
  subnet_id      = aws_subnet.main-public-3.id
}