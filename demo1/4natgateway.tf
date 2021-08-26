#Setup Elastic IP to be used with Nat Gateway as the connectivity_type attribute of nat_gateway is by defauot 'public'
resource "aws_eip" "nat" {
  vpc = true

}

resource "aws_nat_gateway" "main-private" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${module.main-public-1.subnet_id}"
  depends_on = [
    aws_internet_gateway.main-gw]
}

resource "aws_route_table" "main-private" {
  vpc_id = "${module.common-vpc.this_vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main-private.id}"
  }
  tags = {
    Name = "Main Private"
  }
}

resource "aws_route_table_association" "main-private-1-a" {
  route_table_id = "${aws_route_table.main-private.id}"
  subnet_id = "${module.main-private-1.subnet_id}"
}

resource "aws_route_table_association" "main-private-1-b" {
  route_table_id = "${aws_route_table.main-private.id}"
  subnet_id = "${module.main-private-2.subnet_id}"
}