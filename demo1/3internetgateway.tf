#Create an internet gateway and associate it with the VPC from step 1
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${module.common-vpc.this_vpc_id}"
  tags = {
    Name = "Main Gateway"
  }
}

#Setup route table for access to and from internet via publiic subnet 1 and 2
resource "aws_route_table" "main-public" {
  vpc_id = "${module.common-vpc.this_vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "main-public"
  }
}

resource "aws_route_table_association" "main-public-1-a" {
  route_table_id = "${aws_route_table.main-public.id}"
  subnet_id = "${module.main-public-1.subnet_id}"
}

resource "aws_route_table_association" "main-public-1-b" {
  route_table_id = "${aws_route_table.main-public.id}"
  subnet_id = "${module.main-public-2.subnet_id}"
}